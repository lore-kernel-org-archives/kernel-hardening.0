From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH 1/4] gpio: Remove VLA from gpiolib
Date: Fri,  9 Mar 2018 16:10:18 -0800
Message-Id: <20180310001021.6437-2-labbott@redhat.com>
In-Reply-To: <20180310001021.6437-1-labbott@redhat.com>
References: <20180310001021.6437-1-labbott@redhat.com>
To: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Lukas Wunner <lukas@wunner.de>, Mathias Duckeck <m.duckeck@kunbus.de>, Nandor Han <nandor.han@ge.com>, Semi Malinen <semi.malinen@ge.com>, Patrice Chotard <patrice.chotard@st.com>
List-ID: <kernel-hardening.lists.openwall.com>



The new challenge is to remove VLAs from the kernel
(see https://lkml.org/lkml/2018/3/7/621)

This patch replaces several VLAs with an appropriate call to
kmalloc_array.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/gpio/gpiolib.c | 55 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d66de67ef307..124727c74931 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2662,16 +2662,33 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
 
 	while (i < array_size) {
 		struct gpio_chip *chip = desc_array[i]->gdev->chip;
-		unsigned long mask[BITS_TO_LONGS(chip->ngpio)];
-		unsigned long bits[BITS_TO_LONGS(chip->ngpio)];
+		unsigned long *mask;
+		unsigned long *bits;
 		int first, j, ret;
 
+		mask = kmalloc_array(BITS_TO_LONGS(chip->ngpio),
+				sizeof(*mask),
+				can_sleep ? GFP_KERNEL : GFP_ATOMIC);
+
+		if (!mask)
+			return -ENOMEM;
+
+		bits = kmalloc_array(BITS_TO_LONGS(chip->ngpio),
+				sizeof(*bits),
+				can_sleep ? GFP_KERNEL : GFP_ATOMIC);
+
+		if (!bits) {
+			kfree(mask);
+			return -ENOMEM;
+		}
+
+
 		if (!can_sleep)
 			WARN_ON(chip->can_sleep);
 
 		/* collect all inputs belonging to the same chip */
 		first = i;
-		memset(mask, 0, sizeof(mask));
+		memset(mask, 0, sizeof(*mask));
 		do {
 			const struct gpio_desc *desc = desc_array[i];
 			int hwgpio = gpio_chip_hwgpio(desc);
@@ -2682,8 +2699,11 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
 			 (desc_array[i]->gdev->chip == chip));
 
 		ret = gpio_chip_get_multiple(chip, mask, bits);
-		if (ret)
+		if (ret) {
+			kfree(bits);
+			kfree(mask);
 			return ret;
+		}
 
 		for (j = first; j < i; j++) {
 			const struct gpio_desc *desc = desc_array[j];
@@ -2695,6 +2715,8 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
 			value_array[j] = value;
 			trace_gpio_value(desc_to_gpio(desc), 1, value);
 		}
+		kfree(bits);
+		kfree(mask);
 	}
 	return 0;
 }
@@ -2887,14 +2909,30 @@ void gpiod_set_array_value_complex(bool raw, bool can_sleep,
 
 	while (i < array_size) {
 		struct gpio_chip *chip = desc_array[i]->gdev->chip;
-		unsigned long mask[BITS_TO_LONGS(chip->ngpio)];
-		unsigned long bits[BITS_TO_LONGS(chip->ngpio)];
+		unsigned long *mask;
+		unsigned long *bits;
 		int count = 0;
 
+		mask = kmalloc_array(BITS_TO_LONGS(chip->ngpio),
+				sizeof(*mask),
+				can_sleep ? GFP_KERNEL : GFP_ATOMIC);
+
+		if (!mask)
+			return;
+
+		bits = kmalloc_array(BITS_TO_LONGS(chip->ngpio),
+				sizeof(*bits),
+				can_sleep ? GFP_KERNEL : GFP_ATOMIC);
+
+		if (!bits) {
+			kfree(mask);
+			return;
+		}
+
 		if (!can_sleep)
 			WARN_ON(chip->can_sleep);
 
-		memset(mask, 0, sizeof(mask));
+		memset(mask, 0, sizeof(*mask));
 		do {
 			struct gpio_desc *desc = desc_array[i];
 			int hwgpio = gpio_chip_hwgpio(desc);
@@ -2925,6 +2963,9 @@ void gpiod_set_array_value_complex(bool raw, bool can_sleep,
 		/* push collected bits to outputs */
 		if (count != 0)
 			gpio_chip_set_multiple(chip, mask, bits);
+
+		kfree(mask);
+		kfree(bits);
 	}
 }
 
-- 
2.14.3
