From: Laura Abbott <labbott@redhat.com>
Subject: [PATCHv2 1/4] gpio: Remove VLA from gpiolib
Date: Thu, 15 Mar 2018 11:00:27 -0700
Message-Id: <20180315180030.20001-2-labbott@redhat.com>
In-Reply-To: <20180315180030.20001-1-labbott@redhat.com>
References: <20180315180030.20001-1-labbott@redhat.com>
To: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Lukas Wunner <lukas@wunner.de>, Mathias Duckeck <m.duckeck@kunbus.de>, Nandor Han <nandor.han@ge.com>, Patrice Chotard <patrice.chotard@st.com>
List-ID: <kernel-hardening.lists.openwall.com>


The new challenge is to remove VLAs from the kernel
(see https://lkml.org/lkml/2018/3/7/621) to eventually
turn on -Wvla.

This patch replaces several VLAs with an appropriate call to
kmalloc_array.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
v2: Switched to kcalloc. Adjusted return types to propegate error code.
---
 drivers/gpio/gpiolib.c        | 76 ++++++++++++++++++++++++++++++++++---------
 drivers/gpio/gpiolib.h        |  2 +-
 include/linux/gpio/consumer.h |  8 +++--
 3 files changed, 66 insertions(+), 20 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d66de67ef307..c81e5d0aea42 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -390,6 +390,7 @@ static long linehandle_ioctl(struct file *filep, unsigned int cmd,
 
 		return 0;
 	} else if (cmd == GPIOHANDLE_SET_LINE_VALUES_IOCTL) {
+		int ret;
 		/* TODO: check if descriptors are really output */
 		if (copy_from_user(&ghd, ip, sizeof(ghd)))
 			return -EFAULT;
@@ -399,11 +400,14 @@ static long linehandle_ioctl(struct file *filep, unsigned int cmd,
 			vals[i] = !!ghd.values[i];
 
 		/* Reuse the array setting function */
-		gpiod_set_array_value_complex(false,
+		ret = gpiod_set_array_value_complex(false,
 					      true,
 					      lh->numdescs,
 					      lh->descs,
 					      vals);
+		if (ret)
+			return ret;
+
 		return 0;
 	}
 	return -EINVAL;
@@ -2662,16 +2666,32 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
 
 	while (i < array_size) {
 		struct gpio_chip *chip = desc_array[i]->gdev->chip;
-		unsigned long mask[BITS_TO_LONGS(chip->ngpio)];
-		unsigned long bits[BITS_TO_LONGS(chip->ngpio)];
+		unsigned long *mask;
+		unsigned long *bits;
 		int first, j, ret;
 
+		mask = kcalloc(BITS_TO_LONGS(chip->ngpio),
+				sizeof(*mask),
+				can_sleep ? GFP_KERNEL : GFP_ATOMIC);
+
+		if (!mask)
+			return -ENOMEM;
+
+		bits = kcalloc(BITS_TO_LONGS(chip->ngpio),
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
 		do {
 			const struct gpio_desc *desc = desc_array[i];
 			int hwgpio = gpio_chip_hwgpio(desc);
@@ -2682,8 +2702,11 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
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
@@ -2695,6 +2718,8 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
 			value_array[j] = value;
 			trace_gpio_value(desc_to_gpio(desc), 1, value);
 		}
+		kfree(bits);
+		kfree(mask);
 	}
 	return 0;
 }
@@ -2878,7 +2903,7 @@ static void gpio_chip_set_multiple(struct gpio_chip *chip,
 	}
 }
 
-void gpiod_set_array_value_complex(bool raw, bool can_sleep,
+int gpiod_set_array_value_complex(bool raw, bool can_sleep,
 				   unsigned int array_size,
 				   struct gpio_desc **desc_array,
 				   int *value_array)
@@ -2887,14 +2912,29 @@ void gpiod_set_array_value_complex(bool raw, bool can_sleep,
 
 	while (i < array_size) {
 		struct gpio_chip *chip = desc_array[i]->gdev->chip;
-		unsigned long mask[BITS_TO_LONGS(chip->ngpio)];
-		unsigned long bits[BITS_TO_LONGS(chip->ngpio)];
+		unsigned long *mask;
+		unsigned long *bits;
 		int count = 0;
 
+		mask = kcalloc(BITS_TO_LONGS(chip->ngpio),
+				sizeof(*mask),
+				can_sleep ? GFP_KERNEL : GFP_ATOMIC);
+
+		if (!mask)
+			return -ENOMEM;
+
+		bits = kcalloc(BITS_TO_LONGS(chip->ngpio),
+				sizeof(*bits),
+				can_sleep ? GFP_KERNEL : GFP_ATOMIC);
+
+		if (!bits) {
+			kfree(mask);
+			return -ENOMEM;
+		}
+
 		if (!can_sleep)
 			WARN_ON(chip->can_sleep);
 
-		memset(mask, 0, sizeof(mask));
 		do {
 			struct gpio_desc *desc = desc_array[i];
 			int hwgpio = gpio_chip_hwgpio(desc);
@@ -2925,7 +2965,11 @@ void gpiod_set_array_value_complex(bool raw, bool can_sleep,
 		/* push collected bits to outputs */
 		if (count != 0)
 			gpio_chip_set_multiple(chip, mask, bits);
+
+		kfree(mask);
+		kfree(bits);
 	}
+	return 0;
 }
 
 /**
@@ -3000,13 +3044,13 @@ EXPORT_SYMBOL_GPL(gpiod_set_value);
  * This function should be called from contexts where we cannot sleep, and will
  * complain if the GPIO chip functions potentially sleep.
  */
-void gpiod_set_raw_array_value(unsigned int array_size,
+int gpiod_set_raw_array_value(unsigned int array_size,
 			 struct gpio_desc **desc_array, int *value_array)
 {
 	if (!desc_array)
-		return;
-	gpiod_set_array_value_complex(true, false, array_size, desc_array,
-				      value_array);
+		return -EINVAL;
+	return gpiod_set_array_value_complex(true, false, array_size,
+					desc_array, value_array);
 }
 EXPORT_SYMBOL_GPL(gpiod_set_raw_array_value);
 
@@ -3326,14 +3370,14 @@ EXPORT_SYMBOL_GPL(gpiod_set_value_cansleep);
  *
  * This function is to be called from contexts that can sleep.
  */
-void gpiod_set_raw_array_value_cansleep(unsigned int array_size,
+int gpiod_set_raw_array_value_cansleep(unsigned int array_size,
 					struct gpio_desc **desc_array,
 					int *value_array)
 {
 	might_sleep_if(extra_checks);
 	if (!desc_array)
-		return;
-	gpiod_set_array_value_complex(true, true, array_size, desc_array,
+		return -EINVAL;
+	return gpiod_set_array_value_complex(true, true, array_size, desc_array,
 				      value_array);
 }
 EXPORT_SYMBOL_GPL(gpiod_set_raw_array_value_cansleep);
diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
index b17ec6795c81..b64813e3876e 100644
--- a/drivers/gpio/gpiolib.h
+++ b/drivers/gpio/gpiolib.h
@@ -188,7 +188,7 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
 				  unsigned int array_size,
 				  struct gpio_desc **desc_array,
 				  int *value_array);
-void gpiod_set_array_value_complex(bool raw, bool can_sleep,
+int gpiod_set_array_value_complex(bool raw, bool can_sleep,
 				   unsigned int array_size,
 				   struct gpio_desc **desc_array,
 				   int *value_array);
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index dbd065963296..da52610cc3bd 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -116,7 +116,7 @@ int gpiod_get_raw_array_value(unsigned int array_size,
 			      struct gpio_desc **desc_array,
 			      int *value_array);
 void gpiod_set_raw_value(struct gpio_desc *desc, int value);
-void gpiod_set_raw_array_value(unsigned int array_size,
+int gpiod_set_raw_array_value(unsigned int array_size,
 			       struct gpio_desc **desc_array,
 			       int *value_array);
 
@@ -134,7 +134,7 @@ int gpiod_get_raw_array_value_cansleep(unsigned int array_size,
 				       struct gpio_desc **desc_array,
 				       int *value_array);
 void gpiod_set_raw_value_cansleep(struct gpio_desc *desc, int value);
-void gpiod_set_raw_array_value_cansleep(unsigned int array_size,
+int gpiod_set_raw_array_value_cansleep(unsigned int array_size,
 					struct gpio_desc **desc_array,
 					int *value_array);
 
@@ -369,12 +369,13 @@ static inline void gpiod_set_raw_value(struct gpio_desc *desc, int value)
 	/* GPIO can never have been requested */
 	WARN_ON(1);
 }
-static inline void gpiod_set_raw_array_value(unsigned int array_size,
+static inline int gpiod_set_raw_array_value(unsigned int array_size,
 					     struct gpio_desc **desc_array,
 					     int *value_array)
 {
 	/* GPIO can never have been requested */
 	WARN_ON(1);
+	return 0;
 }
 
 static inline int gpiod_get_value_cansleep(const struct gpio_desc *desc)
@@ -429,6 +430,7 @@ static inline void gpiod_set_raw_array_value_cansleep(unsigned int array_size,
 {
 	/* GPIO can never have been requested */
 	WARN_ON(1);
+	return 0;
 }
 
 static inline int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
-- 
2.14.3
