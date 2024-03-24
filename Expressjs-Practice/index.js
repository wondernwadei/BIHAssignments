 constexpress = require("express")

const { getDefaultProvider, isAddress, Contract } = require("ethers");

const app = express()

const provider = getDefaultProvider('https://arbitrum-sepolia.blockpi.network/v1/rpc/public')

app.get('/getBalance/:address', async function(req, res) {

    const address = req.params.address;

    if(!isAddress(address)) {
        return res.status(400).json({'message': `the address ${address} provided is invalid`})
    }

    const balance = await provider.getBalance(address)

    return res.status(200).json({'balance': balance.toString(), 'address': address})
})

app.get('/getBalance/:token/:address', async function(req, res) {
    const tokenAddress = req.params.token;

    if(!isAddress(tokenAddress)) {
        return res.status(400).json({'message': `the token address ${tokenAddress} provided is invalid`})
    }

    const address = req.params.address;

    if(!isAddress(address)) {
      return res.status(400).json({'message': `the address ${address} provided is invalid`})
  }

    const token = new Contract(tokenAddress,  [
       
        {
          "constant": true,
          "inputs": [
            {
              "name": "_owner",
              "type": "address"
            }
          ],
          "name": "balanceOf",
          "outputs": [
            {
              "name": "balance",
              "type": "uint256"
            }
          ],
          "payable": false,
          "type": "function"
        }
      ], provider)


      const balance = await token.balanceOf(address)

      return res.status(200).json({'balance': balance.toString(), 'address': address, token: tokenAddress})

})

app.listen(3020, function() {
    console.log("server started on port 3020")
})


