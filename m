From: Laura Abbott <labbott@redhat.com>
Subject: [PATCHv3] gpio: Remove VLA from gpiolib
Date: Wed, 28 Mar 2018 11:18:09 -0700
Message-Id: <20180328181809.24505-1-labbott@redhat.com>
To: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>
Cc: Laura Abbott <labbott@redhat.com>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-ID: <kernel-hardening.lists.openwall.com>

The new challenge is to remove VLAs from the kernel
(see https://lkml.org/lkml/2018/3/7/621) to eventually
turn on -Wvla.

Using a kmalloc array is the easy way to fix this but kmalloc is still
more expensive than stack allocation. Introduce a fast path with a
fixed size stack array to cover most chip with gpios below some fixed
amount. The slow path dynamically allocates an array to cover those
chips with a large number of gpios.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Laura Abbott <labbott@redhat.com>
---
v3: Split out from the series since patches have been picked up
independently. Fold in patch from Lukas Wunner to introduce slow/fast
paths. I took his suggestions to go with 384 as the maximum number of
gpios. Also fixed one 0-day bot issue where I forgot to change the
return type.
---
 drivers/gpio/gpiolib.c        | 74 +++++++++++++++++++++++++++++++++----------
 drivers/gpio/gpiolib.h        |  2 +-
 include/linux/gpio/consumer.h | 10 +++---
 3 files changed, 65 insertions(+), 21 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d66de67ef307..e3ca9e31bcbc 100644
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
@@ -2653,6 +2657,8 @@ static int gpio_chip_get_multiple(struct gpio_chip *chip,
 	return -EIO;
 }
 
+#define FASTPATH_NGPIO 384
+
 int gpiod_get_array_value_complex(bool raw, bool can_sleep,
 				  unsigned int array_size,
 				  struct gpio_desc **desc_array,
@@ -2662,16 +2668,29 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
 
 	while (i < array_size) {
 		struct gpio_chip *chip = desc_array[i]->gdev->chip;
-		unsigned long mask[BITS_TO_LONGS(chip->ngpio)];
-		unsigned long bits[BITS_TO_LONGS(chip->ngpio)];
+		unsigned long fastpath[2 * BITS_TO_LONGS(FASTPATH_NGPIO)];
+		unsigned long *slowpath = NULL, *mask, *bits;
 		int first, j, ret;
 
+		if (likely(chip->ngpio <= FASTPATH_NGPIO)) {
+			memset(fastpath, 0, sizeof(fastpath));
+			mask = fastpath;
+			bits = fastpath + BITS_TO_LONGS(FASTPATH_NGPIO);
+		} else {
+			slowpath = kcalloc(2 * BITS_TO_LONGS(chip->ngpio),
+					   sizeof(*slowpath),
+					   can_sleep ? GFP_KERNEL : GFP_ATOMIC);
+			if (!slowpath)
+				return -ENOMEM;
+			mask = slowpath;
+			bits = slowpath + BITS_TO_LONGS(chip->ngpio);
+		}
+
 		if (!can_sleep)
 			WARN_ON(chip->can_sleep);
 
 		/* collect all inputs belonging to the same chip */
 		first = i;
-		memset(mask, 0, sizeof(mask));
 		do {
 			const struct gpio_desc *desc = desc_array[i];
 			int hwgpio = gpio_chip_hwgpio(desc);
@@ -2682,8 +2701,11 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
 			 (desc_array[i]->gdev->chip == chip));
 
 		ret = gpio_chip_get_multiple(chip, mask, bits);
-		if (ret)
+		if (ret) {
+			if (slowpath)
+				kfree(slowpath);
 			return ret;
+		}
 
 		for (j = first; j < i; j++) {
 			const struct gpio_desc *desc = desc_array[j];
@@ -2695,6 +2717,9 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
 			value_array[j] = value;
 			trace_gpio_value(desc_to_gpio(desc), 1, value);
 		}
+
+		if (slowpath)
+			kfree(slowpath);
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
@@ -2887,14 +2912,27 @@ void gpiod_set_array_value_complex(bool raw, bool can_sleep,
 
 	while (i < array_size) {
 		struct gpio_chip *chip = desc_array[i]->gdev->chip;
-		unsigned long mask[BITS_TO_LONGS(chip->ngpio)];
-		unsigned long bits[BITS_TO_LONGS(chip->ngpio)];
+		unsigned long fastpath[2 * BITS_TO_LONGS(FASTPATH_NGPIO)];
+		unsigned long *slowpath = NULL, *mask, *bits;
 		int count = 0;
 
+		if (likely(chip->ngpio <= FASTPATH_NGPIO)) {
+			memset(fastpath, 0, sizeof(fastpath));
+			mask = fastpath;
+			bits = fastpath + BITS_TO_LONGS(FASTPATH_NGPIO);
+		} else {
+			slowpath = kcalloc(2 * BITS_TO_LONGS(chip->ngpio),
+					   sizeof(*slowpath),
+					   can_sleep ? GFP_KERNEL : GFP_ATOMIC);
+			if (!slowpath)
+				return -ENOMEM;
+			mask = slowpath;
+			bits = slowpath + BITS_TO_LONGS(chip->ngpio);
+		}
+
 		if (!can_sleep)
 			WARN_ON(chip->can_sleep);
 
-		memset(mask, 0, sizeof(mask));
 		do {
 			struct gpio_desc *desc = desc_array[i];
 			int hwgpio = gpio_chip_hwgpio(desc);
@@ -2925,7 +2963,11 @@ void gpiod_set_array_value_complex(bool raw, bool can_sleep,
 		/* push collected bits to outputs */
 		if (count != 0)
 			gpio_chip_set_multiple(chip, mask, bits);
+
+		if (slowpath)
+			kfree(slowpath);
 	}
+	return 0;
 }
 
 /**
@@ -3000,13 +3042,13 @@ EXPORT_SYMBOL_GPL(gpiod_set_value);
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
 
@@ -3326,14 +3368,14 @@ EXPORT_SYMBOL_GPL(gpiod_set_value_cansleep);
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
index dbd065963296..243112c7fa7d 100644
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
@@ -423,12 +424,13 @@ static inline void gpiod_set_raw_value_cansleep(struct gpio_desc *desc,
 	/* GPIO can never have been requested */
 	WARN_ON(1);
 }
-static inline void gpiod_set_raw_array_value_cansleep(unsigned int array_size,
+static inline int gpiod_set_raw_array_value_cansleep(unsigned int array_size,
 						struct gpio_desc **desc_array,
 						int *value_array)
 {
 	/* GPIO can never have been requested */
 	WARN_ON(1);
+	return 0;
 }
 
 static inline int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
-- 
2.14.3
