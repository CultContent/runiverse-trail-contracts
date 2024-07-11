import { expect } from 'chai';
import "@openzeppelin/hardhat-upgrades"
import { upgrades } from 'hardhat';
import hre from 'hardhat';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { Contract } from 'ethers';

describe('Villagers', function () {
    let contract: Contract;
    let owner: SignerWithAddress;
    let otherUser: SignerWithAddress;

    beforeEach(async function () {
        const Contract = await hre.ethers.getContractFactory('Villagers');

        const [_owner, _otherUser] = await hre.ethers.getSigners();
        owner = _owner;
        otherUser = _otherUser;

        contract = await upgrades.deployProxy(Contract);
        await contract.deployed();
    });

    describe('setters', function () {
        describe('owner', function () {
            it('should successfully set and retrieve baseURI', async () => {
                const newURI = 'ipfs://testuri';
                await contract.setBaseURI(newURI);
                await expect(await contract.baseURI()).to.equal(newURI);
            });
        });

        describe('non-owner', function () {
            it('should not be able to setBaseURI', async () => {
                await expect(
                    contract.connect(otherUser).setBaseURI('ipfs://123/')
                ).to.be.rejectedWith('Ownable: caller is not the owner');
            });
        });

        describe('emits', function () {
            it('BaseURIUpdated event', async function () {
                await contract.setBaseURI('ipfs://old');
                await expect(contract.setBaseURI('ipfs://new'))
                    .to.emit(contract, 'BaseURIUpdated')
                    .withArgs('ipfs://old', 'ipfs://new');
            });
        });
    });

    describe('mint', function () {
        it('should not mint if already owns', async function () {
            await contract.mintItem(otherUser.address);

            await expect(
                contract.mintItem(otherUser.address)
            ).to.be.revertedWith('AlreadyMinted');
        });

        describe('upon successful mint (when value is equal to mintPrice)', function () {
            it('should emit a LogTokenMinted', async function () {
                await expect(
                    contract.mintItem(otherUser.address)
                )
                    .to.emit(contract, 'TokenMinted')
                    .withArgs(otherUser.address, 1);
            });

            it('should be owned by otherUser', async function () {
                await contract.mintItem(otherUser.address);

                await expect(await contract.ownerOf(1)).to.equal(
                    otherUser.address
                );
            });

            it('non-owner should also be successful and emit a LogTokenMinted', async function () {
                await expect(
                    contract.connect(otherUser).mintItem(otherUser.address)
                )
                    .to.emit(contract, 'TokenMinted')
                    .withArgs(otherUser.address, 1);
            });
        });
    });
});