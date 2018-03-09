Date: Thu, 8 Mar 2018 22:58:13 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] power: supply: da9150-fg: remove VLA usage
Message-ID: <20180309045813.GA11964@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: Support Opensource <support.opensource@diasemi.com>, Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

In preparation to enabling -Wvla, remove VLA usage and replace it
with fixed-length arrays.

It seems that the length of array 'buf' will not exceed
DA9150_QIF_SHORT_SIZE bytes (2 bytes). But a fixed length
of DA9150_QIF_BYTE_SIZE bytes (8 bytes) was chosen in case
this change in the future.

Fixed as part of the directive to remove all VLAs from
the kernel: https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/power/supply/da9150-fg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/da9150-fg.c b/drivers/power/supply/da9150-fg.c
index 8b8ce97..96893be 100644
--- a/drivers/power/supply/da9150-fg.c
+++ b/drivers/power/supply/da9150-fg.c
@@ -92,7 +92,7 @@ struct da9150_fg {
 static u32 da9150_fg_read_attr(struct da9150_fg *fg, u8 code, u8 size)
 
 {
-	u8 buf[size];
+	u8 buf[DA9150_QIF_BYTE_SIZE];
 	u8 read_addr;
 	u32 res = 0;
 	int i;
@@ -111,7 +111,7 @@ static void da9150_fg_write_attr(struct da9150_fg *fg, u8 code, u8 size,
 				 u32 val)
 
 {
-	u8 buf[size];
+	u8 buf[DA9150_QIF_BYTE_SIZE];
 	u8 write_addr;
 	int i;
 
-- 
2.7.4
