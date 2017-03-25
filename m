Date: Fri, 24 Mar 2017 17:40:40 -0700
From: Jessica Yu <jeyu@redhat.com>
Message-ID: <20170325004040.azlzgcmedusypah5@jeyu>
References: <20170323025549.19588-1-ewk@edkovsky.org>
 <20170323025549.19588-2-ewk@edkovsky.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20170323025549.19588-2-ewk@edkovsky.org>
Subject: [kernel-hardening] Re: [PATCH v3 1/2] module: verify address is read-only
To: Eddie Kovsky <ewk@edkovsky.org>
Cc: rusty@rustcorp.com.au, keescook@chromium.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

+++ Eddie Kovsky [22/03/17 20:55 -0600]:
>Implement a mechanism to check if a module's address is in
>the rodata or ro_after_init sections. It mimics the exsiting functions
>that test if an address is inside a module's text section.
>
>Functions that take a module as an argument will be able to

>verify that the module is in a read-only section.

s/module/module address/?

Also, there is some useful information in your cover letter on the
context and motivation for adding to the api, it would be good to
reproduce that info here so that we can have it officially in the
changelog. (sentences "This implements a suggestion made by Kees..."
and "The idea is to prevent structures..." would be nice to copy here)

>Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
>---
>Changes in v3:
> - Change function name is_module_ro_address() to
>is_module_rodata_address().
> - Improve comments on is_module_rodata_address().
> - Add a !CONFIG_MODULES stub for is_module_rodata_address.
> - Correct and simplify the check for the read-only memory regions in
>the module address.
>
> include/linux/module.h | 12 ++++++++++++
> kernel/module.c        | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 65 insertions(+)
>
>diff --git a/include/linux/module.h b/include/linux/module.h
>index 9ad68561d8c2..66b7fd321334 100644
>--- a/include/linux/module.h
>+++ b/include/linux/module.h
>@@ -492,7 +492,9 @@ static inline int module_is_live(struct module *mod)
>
> struct module *__module_text_address(unsigned long addr);
> struct module *__module_address(unsigned long addr);
>+struct module *__module_ro_address(unsigned long addr);

Can we rename __module_ro_address to __module_rodata_address (to match
is_module_rodata_address())?

> bool is_module_address(unsigned long addr);
>+bool is_module_rodata_address(unsigned long addr);
> bool __is_module_percpu_address(unsigned long addr, unsigned long *can_addr);
> bool is_module_percpu_address(unsigned long addr);
> bool is_module_text_address(unsigned long addr);
>@@ -646,6 +648,16 @@ static inline struct module *__module_address(unsigned long addr)
> 	return NULL;
> }
>
>+static inline struct module *__module_ro_address(unsigned long addr)
>+{
>+	return NULL;
>+}
>+
>+static inline bool is_module_rodata_address(unsigned long addr)
>+{
>+	return false;
>+}
>+

Style nitpick: Can you move is_module_rodata_address() below is_module_address()?
That way, the function stubs are grouped a bit more consistently.

> static inline struct module *__module_text_address(unsigned long addr)
> {
> 	return NULL;
>diff --git a/kernel/module.c b/kernel/module.c
>index 8ffcd29a4245..99ada1257aaa 100644
>--- a/kernel/module.c
>+++ b/kernel/module.c
>@@ -4292,6 +4292,59 @@ struct module *__module_text_address(unsigned long addr)
> }
> EXPORT_SYMBOL_GPL(__module_text_address);
>
>+/**
>+ * is_module_rodata_address - is this address inside read-only module code?

s/code/data/

>+ * @addr: the address to check.
>+ *
>+ */
>+bool is_module_rodata_address(unsigned long addr)
>+{
>+	bool ret;
>+
>+	preempt_disable();
>+	ret = __module_ro_address(addr) != NULL;
>+	preempt_enable();
>+
>+	return ret;
>+}
>+
>+/*
>+ * __module_ro_address - get the module whose rodata/ro_after_init sections
>+ * contain the given address.

As mentioned in the first comment, let's rename __module_ro_address to
__module_rodata_address, so it mirrors is_module_rodata_address().

>+ * @addr: the address.
>+ *
>+ * Must be called with preempt disabled or module mutex held so that
>+ * module doesn't get freed during this.
>+ */
>+struct module *__module_ro_address(unsigned long addr)
>+{
>+	struct module *mod = __module_address(addr);

We need to check that mod is not NULL before dereferencing it below.

>+	void *init_base = mod->init_layout.base;
>+	unsigned int init_text_size = mod->init_layout.text_size;
>+	unsigned int init_ro_after_init_size = mod->init_layout.ro_after_init_size;
>+
>+	void *core_base = mod->core_layout.base;
>+	unsigned int core_text_size = mod->core_layout.text_size;
>+	unsigned int core_ro_after_init_size = mod->core_layout.ro_after_init_size;
>+
>+	/*
>+	 * Make sure module is within the read-only section.
>+	 * range(base + text_size, base + ro_after_init_size)
>+	 * encompasses both the rodata and ro_after_init regions.
>+	 * See comment above frob_text() for the layout diagram.
>+	 */
>+	if (mod) {
>+		if (!within(addr, init_base + init_text_size,
>+			    init_ro_after_init_size - init_text_size)
>+		    && !within(addr, core_base + core_text_size,
>+			       core_ro_after_init_size - core_text_size))
>+			mod = NULL;
>+	}
>+	return mod;
>+}
>+EXPORT_SYMBOL_GPL(__module_ro_address);
>+
> /* Don't grab lock, we're oopsing. */
> void print_modules(void)
> {
>--
>2.12.0
