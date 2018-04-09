From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH] gpio: xra1403: Switch to a fixed upper bound for registers
Date: Mon,  9 Apr 2018 14:07:17 -0700
Message-Id: <20180409210717.3852-1-labbott@redhat.com>
To: Nandor Han <nandor.han@ge.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Kees Cook <keescook@chromium.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>, linux-gpio@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Geert Uytterhoeven pointed out that the number of register was a
fixed upper bound so there's no need to use a dynamically allocated
array in place of a VLA. Use the defined upper bound.

Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/gpio/gpio-xra1403.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/gpio/gpio-xra1403.c b/drivers/gpio/gpio-xra1403.c
index 8d4c8e99b251..8711a7907568 100644
--- a/drivers/gpio/gpio-xra1403.c
+++ b/drivers/gpio/gpio-xra1403.c
@@ -39,6 +39,7 @@
 #define XRA_REIR  0x10 /* Input Rising Edge Interrupt Enable */
 #define XRA_FEIR  0x12 /* Input Falling Edge Interrupt Enable */
 #define XRA_IFR   0x14 /* Input Filter Enable/Disable */
+#define XRA_LAST  0x15 /* Bounds */
 
 struct xra1403 {
 	struct gpio_chip  chip;
@@ -50,7 +51,7 @@ static const struct regmap_config xra1403_regmap_cfg = {
 		.pad_bits = 1,
 		.val_bits = 8,
 
-		.max_register = XRA_IFR | 0x01,
+		.max_register = XRA_LAST,
 };
 
 static unsigned int to_reg(unsigned int reg, unsigned int offset)
@@ -126,21 +127,16 @@ static void xra1403_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 {
 	int reg;
 	struct xra1403 *xra = gpiochip_get_data(chip);
-	int *value;
+	int value[XRA_LAST];
 	int i;
 	unsigned int gcr;
 	unsigned int gsr;
 
-	value = kmalloc_array(xra1403_regmap_cfg.max_register, sizeof(*value),
-				GFP_KERNEL);
-	if (!value)
-		return;
-
 	seq_puts(s, "xra reg:");
-	for (reg = 0; reg <= xra1403_regmap_cfg.max_register; reg++)
+	for (reg = 0; reg <= XRA_LAST; reg++)
 		seq_printf(s, " %2.2x", reg);
 	seq_puts(s, "\n  value:");
-	for (reg = 0; reg < xra1403_regmap_cfg.max_register; reg++) {
+	for (reg = 0; reg < XRA_LAST; reg++) {
 		regmap_read(xra->regmap, reg, &value[reg]);
 		seq_printf(s, " %2.2x", value[reg]);
 	}
@@ -159,7 +155,6 @@ static void xra1403_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 			   (gcr & BIT(i)) ? "in" : "out",
 			   (gsr & BIT(i)) ? "hi" : "lo");
 	}
-	kfree(value);
 }
 #else
 #define xra1403_dbg_show NULL
-- 
2.14.3
