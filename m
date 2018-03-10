From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH 3/4] gpio: Remove VLA from xra1403 driver
Date: Fri,  9 Mar 2018 16:10:20 -0800
Message-Id: <20180310001021.6437-4-labbott@redhat.com>
In-Reply-To: <20180310001021.6437-1-labbott@redhat.com>
References: <20180310001021.6437-1-labbott@redhat.com>
To: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Nandor Han <nandor.han@ge.com>, Semi Malinen <semi.malinen@ge.com>
Cc: Laura Abbott <labbott@redhat.com>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


The new challenge is to remove VLAs from the kernel
(see https://lkml.org/lkml/2018/3/7/621)

This patch replaces a VLA with an appropriate call to kmalloc_array.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/gpio/gpio-xra1403.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-xra1403.c b/drivers/gpio/gpio-xra1403.c
index 0230e4b7a2fb..8d4c8e99b251 100644
--- a/drivers/gpio/gpio-xra1403.c
+++ b/drivers/gpio/gpio-xra1403.c
@@ -126,11 +126,16 @@ static void xra1403_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 {
 	int reg;
 	struct xra1403 *xra = gpiochip_get_data(chip);
-	int value[xra1403_regmap_cfg.max_register];
+	int *value;
 	int i;
 	unsigned int gcr;
 	unsigned int gsr;
 
+	value = kmalloc_array(xra1403_regmap_cfg.max_register, sizeof(*value),
+				GFP_KERNEL);
+	if (!value)
+		return;
+
 	seq_puts(s, "xra reg:");
 	for (reg = 0; reg <= xra1403_regmap_cfg.max_register; reg++)
 		seq_printf(s, " %2.2x", reg);
@@ -154,6 +159,7 @@ static void xra1403_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 			   (gcr & BIT(i)) ? "in" : "out",
 			   (gsr & BIT(i)) ? "hi" : "lo");
 	}
+	kfree(value);
 }
 #else
 #define xra1403_dbg_show NULL
-- 
2.14.3
