From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH] rsi: Remove stack VLA usage
Date: Fri,  9 Mar 2018 17:38:13 +1100
Message-Id: <1520577493-24603-1-git-send-email-me@tobin.cc>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

The kernel would like to have all stack VLA usage removed[1].  rsi uses
a VLA based on 'blksize'.  Elsewhere in the SDIO code maximum block size
is defined using a magic number.  We can use a pre-processor defined
constant and declare the array to maximum size.  We add a check before
accessing the array in case of programmer error.

[1]: https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c  | 13 +++++++------
 drivers/net/wireless/rsi/rsi_91x_sdio.c |  9 +++++++--
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 1176de646942..839ebdd602df 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -641,7 +641,7 @@ static int ping_pong_write(struct rsi_hw *adapter, u8 cmd, u8 *addr, u32 size)
 	u32 cmd_addr;
 	u16 cmd_resp, cmd_req;
 	u8 *str;
-	int status;
+	int status, ret;
 
 	if (cmd == PING_WRITE) {
 		cmd_addr = PING_BUFFER_ADDRESS;
@@ -655,12 +655,13 @@ static int ping_pong_write(struct rsi_hw *adapter, u8 cmd, u8 *addr, u32 size)
 		str = "PONG_VALID";
 	}
 
-	status = hif_ops->load_data_master_write(adapter, cmd_addr, size,
+	ret = hif_ops->load_data_master_write(adapter, cmd_addr, size,
 					    block_size, addr);
-	if (status) {
-		rsi_dbg(ERR_ZONE, "%s: Unable to write blk at addr %0x\n",
-			__func__, *addr);
-		return status;
+	if (ret) {
+		if (ret != -EINVAL)
+			rsi_dbg(ERR_ZONE, "%s: Unable to write blk at addr %0x\n",
+				__func__, *addr);
+		return ret;
 	}
 
 	status = bl_cmd(adapter, cmd_req, cmd_resp, str);
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index b0cf41195051..b766578b591a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -20,6 +20,8 @@
 #include "rsi_common.h"
 #include "rsi_hal.h"
 
+#define RSI_MAX_BLOCK_SIZE 256
+
 /**
  * rsi_sdio_set_cmd52_arg() - This function prepares cmd 52 read/write arg.
  * @rw: Read/write
@@ -362,7 +364,7 @@ static int rsi_setblocklength(struct rsi_hw *adapter, u32 length)
 	rsi_dbg(INIT_ZONE, "%s: Setting the block length\n", __func__);
 
 	status = sdio_set_block_size(dev->pfunction, length);
-	dev->pfunction->max_blksize = 256;
+	dev->pfunction->max_blksize = RSI_MAX_BLOCK_SIZE;
 	adapter->block_size = dev->pfunction->max_blksize;
 
 	rsi_dbg(INFO_ZONE,
@@ -567,9 +569,12 @@ static int rsi_sdio_load_data_master_write(struct rsi_hw *adapter,
 {
 	u32 num_blocks, offset, i;
 	u16 msb_address, lsb_address;
-	u8 temp_buf[block_size];
+	u8 temp_buf[RSI_MAX_BLOCK_SIZE];
 	int status;
 
+	if (block_size > RSI_MAX_BLOCK_SIZE)
+		return -EINVAL;
+
 	num_blocks = instructions_sz / block_size;
 	msb_address = base_address >> 16;
 
-- 
2.7.4
