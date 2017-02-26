Date: Sun, 26 Feb 2017 12:42:08 -0500
From: Jessica Yu <jeyu@redhat.com>
Message-ID: <20170226174207.GA23992@packer-debian-8-amd64.digitalocean.com>
References: <20170218055844.1457-1-ewk@edkovsky.org>
 <20170218055844.1457-2-ewk@edkovsky.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20170218055844.1457-2-ewk@edkovsky.org>
Subject: [kernel-hardening] Re: [PATCH v2 1/3] module: verify address is read-only
To: Eddie Kovsky <ewk@edkovsky.org>
Cc: rusty@rustcorp.com.au, keescook@chromium.org, kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

+++ Eddie Kovsky [17/02/17 22:58 -0700]:
>Implement a mechanism to check if a module's address is in
>the rodata or ro_after_init sections. It mimics the exsiting functions
>that test if an address is inside a module's text section.

It would be helpful to explain in the changelog the motivation or
reason we're adding to the current api, and why this is needed.

>Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
>---
> include/linux/module.h |  7 +++++++
> kernel/module.c        | 44 ++++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 51 insertions(+)
>
>diff --git a/include/linux/module.h b/include/linux/module.h
>index 0297c5cd7cdf..1608d3570ee2 100644
>--- a/include/linux/module.h
>+++ b/include/linux/module.h
>@@ -492,7 +492,9 @@ static inline int module_is_live(struct module *mod)
>
> struct module *__module_text_address(unsigned long addr);
> struct module *__module_address(unsigned long addr);
>+struct module *__module_ro_address(unsigned long addr);
> bool is_module_address(unsigned long addr);
>+bool is_module_ro_address(unsigned long addr);
> bool is_module_percpu_address(unsigned long addr);
> bool is_module_text_address(unsigned long addr);
>
>@@ -645,6 +647,11 @@ static inline struct module *__module_address(unsigned long addr)
> 	return NULL;
> }
>
>+static inline struct module *__module_ro_address(unsigned long addr)
>+{
>+	return NULL;
>+}
>+

There needs to be a corresponding !CONFIG_MODULES stub for
is_module_ro_address() as well, see is_module_address(), etc.

> static inline struct module *__module_text_address(unsigned long addr)
> {
> 	return NULL;
>diff --git a/kernel/module.c b/kernel/module.c
>index 7eba6dea4f41..298cfe4645b1 100644
>--- a/kernel/module.c
>+++ b/kernel/module.c
>@@ -4275,6 +4275,50 @@ struct module *__module_text_address(unsigned long addr)
> }
> EXPORT_SYMBOL_GPL(__module_text_address);
>
>+/**
>+ * is_module_text_ro_address - is this address inside read-only module code?
>+ * @addr: the address to check.

s/is_module_text_ro_address/is_module_ro_address/

Although I would slightly prefer the name is_module_rodata_address, or
something similar, because it's unclear to me (without looking at the
code) whether the function covers text addresses. And we already have
is_module_text_address() for that case.

>+ *
>+ */
>+bool is_module_ro_address(unsigned long addr)
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
>+ * __module_ro_address - get the module whose code contains a read-only address.

Maybe we should be more specific in the comment and clarify that we're
getting the module whose rodata/ro_after_init sections contain the
given address.

>+ * @addr: the address.
>+ *
>+ * Must be called with preempt disabled or module mutex held so that
>+ * module doesn't get freed during this.
>+ */
>+struct module *__module_ro_address(unsigned long addr)
>+{
>+	struct module *mod = __module_address(addr);
>+
>+	if (mod) {
>+		/* Make sure it's within the read-only section. */
>+		if (!within(addr, mod->init_layout.base,
>+			    mod->init_layout.ro_size)
>+		    && !within(addr, mod->core_layout.base,
>+			       mod->core_layout.ro_size))
>+			mod = NULL;

If a ro_after_init address gets passed in here, mod will be prematurely
set to NULL here, because it is not within [base, base + ro_size).
See comment above frob_text() in module.c for a module layout "diagram".

Also, starting from layout.base will give us the text region as well,
but we just want to check the rodata/ro_after_init regions, same as
what the kernel counterpart in patch 2/3 does. The rodata region
starts at base + text_size.

So we can just simplify this to just one conditional:
(ugly, but shouldn't look bad when cleaned up with some variables)

        if (!within(addr, mod->init_layout.base + mod->init_layout.text_size,
                    mod->init_layout.ro_after_init_size - mod->init_layout.text_size)
         && !within(addr, mod->core_layout.base + mod->core_layout.text_size,
                    mod->core_layout.ro_after_init_size - mod->core_layout.text_size))

This is because range [base + text_size, base + ro_after_init_size)
encompasses both the rodata and ro_after_init regions.

Jessica

>+		if (!within(addr, mod->init_layout.base,
>+			    mod->init_layout.ro_after_init_size)
>+		    && !within(addr, mod->core_layout.base,
>+			       mod->core_layout.ro_after_init_size))
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
>2.11.1
