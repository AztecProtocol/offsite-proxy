import { AccountWallet, CompleteAddress, ContractDeployer, Fr, PXE, waitForPXE, TxStatus, createPXEClient, getContractInstanceFromDeployParams } from "@aztec/aztec.js";
import { getInitialTestAccountsWallets } from "@aztec/accounts/testing"

import { ProxyContractArtifact, ProxyContract } from "../artifacts/ProxyContract.js"
import { TargetContractArtifact, TargetContract } from "../artifacts/TargetContract.js"
// import ___ import from noir-contracts;

describe('proxy calls', () => {
    let pxe: PXE;
    let wallets: AccountWallet[] = [];
    let accounts: CompleteAddress[] = [];
    let target_deployed_address;
    let proxy_contract: ProxyContract;
    let target_contract: TargetContract;

    beforeAll(async () => {
        pxe = await setupSandbox();

        wallets = await getInitialTestAccountsWallets(pxe);
        accounts = wallets.map(w => w.getCompleteAddress())
    })

    it("Deploys the target contract", async () => {
        const salt = Fr.random();
        const publicKey = accounts[0].publicKey
        const TargetContractArtifact = _;
        const deployArgs = accounts[0].address

        const deploymentData = getContractInstanceFromDeployParams(TargetContractArtifact , [deployArgs], salt, publicKey);
        const deployer = new ContractDeployer(TargetContractArtifact , pxe, publicKey);
        const tx = deployer.deploy(deployArgs).send({ contractAddressSalt: salt })
        const receipt = await tx.getReceipt();

        expect(receipt).toEqual(
            expect.objectContaining({
                status: TxStatus.PENDING,
                error: '',
            }),
        );
        const receiptAfterMined = await tx.wait();
        expect(receiptAfterMined).toEqual(
            expect.objectContaining({
                status: TxStatus.MINED,
                error: '',
                contractAddress: deploymentData.address,
            }),
        );
        targetContract = await tx.deployed();
    })

    it("Deploys the proxy contract", async () => {
        const salt = Fr.random();
        const publicKey = accounts[0].publicKey
        const ProxyContractArtifact = _;
        const deployArgs = accounts[0].address

        const deploymentData = getContractInstanceFromDeployParams(ProxyContractArtifact , [deployArgs], salt, publicKey);
        const deployer = new ContractDeployer(ProxyContractArtifact , pxe, publicKey);
        const tx = deployer.deploy(deployArgs).send({ contractAddressSalt: salt })
        const receipt = await tx.getReceipt();

        expect(receipt).toEqual(
            expect.objectContaining({
                status: TxStatus.PENDING,
                error: '',
            }),
        );
        const receiptAfterMined = await tx.wait();
        expect(receiptAfterMined).toEqual(
            expect.objectContaining({
                status: TxStatus.MINED,
                error: '',
                contractAddress: deploymentData.address,
            }),
        );
        proxyContract = await tx.deployed();

    })
    it("Call initialize from within the proxy contract", async () => {
        await proxyContract.methods.test_delegate_call(targetContract.address, targetContract.methods.initialize.selector,[]).send().wait();

    })
        // Call the initialize function within the target contract from the proxy contract
    it("Call the getter function", async () => {
        const contract = await ProxyContract .deploy(wallets[0], accounts[0].address).send().deployed();
        expect(count).toBe(1n);
    })
})
