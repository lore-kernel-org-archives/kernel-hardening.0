Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 14 Nov 2016 15:12:09 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Message-ID: <20161114061208.GI381@linaro.org>
References: <20161021011333.11411-1-takahiro.akashi@linaro.org>
 <20161113030422.ijgbudyagdytvzjz@jeyu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161113030422.ijgbudyagdytvzjz@jeyu>
Subject: [kernel-hardening] Re: module: extend 'rodata=off' boot cmdline parameter to module
 mappings
To: Jessica Yu <jeyu@redhat.com>
Cc: rusty@rustcorp.com.au, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Nov 12, 2016 at 07:04:22PM -0800, Jessica Yu wrote:
> +++ AKASHI Takahiro [21/10/16 10:13 +0900]:
> >The current "rodata=off" parameter disables read-only kernel mappings
> >under CONFIG_DEBUG_RODATA:
> >   commit d2aa1acad22f ("mm/init: Add 'rodata=off' boot cmdline parameter
> >   to disable read-only kernel mappings")
> >
> >This patch is a logical extension to module mappings ie. read-only mappings
> >at module loading can be disabled even if CONFIG_DEBUG_SET_MODULE_RONX
> >(mainly for debug use). Please note, however, that it only affects RO/RW
> >permissions, keeping NX set.
> >
> >This is the first step to make CONFIG_DEBUG_SET_MODULE_RONX mandatory
> >(always-on) in the future as CONFIG_DEBUG_RODATA on x86 and arm64.
> >
> >Suggested-by: Mark Rutland <mark.rutland@arm.com>
> >Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> >Reviewed-by: Kees Cook <keescook@chromium.org>
> >Cc: Rusty Russell <rusty@rustcorp.com.au>
> >---
> >v2:
> > * use CONFIG_DEBUG_RODATA/SET_MODULE_RONX guards better where appropriate
> > * make "rodata_enabled" variable as __ro_after_init
> >v1:
> > * remove RFC's "module_ronx=" and merge it with "rodata="
> > * always keep NX set if CONFIG_SET_MODULE_RONX
> >
> >include/linux/init.h |  3 +++
> >init/main.c          |  7 +++++--
> >kernel/module.c      | 21 ++++++++++++++++++---
> >3 files changed, 26 insertions(+), 5 deletions(-)
> >
> >diff --git a/include/linux/init.h b/include/linux/init.h
> >index e30104c..885c3e6 100644
> >--- a/include/linux/init.h
> >+++ b/include/linux/init.h
> >@@ -126,6 +126,9 @@ void prepare_namespace(void);
> >void __init load_default_modules(void);
> >int __init init_rootfs(void);
> >
> >+#if defined(CONFIG_DEBUG_RODATA) || defined(CONFIG_DEBUG_SET_MODULE_RONX)
> >+extern bool rodata_enabled;
> >+#endif
> >#ifdef CONFIG_DEBUG_RODATA
> >void mark_rodata_ro(void);
> >#endif
> >diff --git a/init/main.c b/init/main.c
> >index 2858be7..959a242 100644
> >--- a/init/main.c
> >+++ b/init/main.c
> >@@ -81,6 +81,7 @@
> >#include <linux/integrity.h>
> >#include <linux/proc_ns.h>
> >#include <linux/io.h>
> >+#include <linux/cache.h>
> >
> >#include <asm/io.h>
> >#include <asm/bugs.h>
> >@@ -914,14 +915,16 @@ static int try_to_run_init_process(const char *init_filename)
> >
> >static noinline void __init kernel_init_freeable(void);
> >
> >-#ifdef CONFIG_DEBUG_RODATA
> >-static bool rodata_enabled = true;
> >+#if defined(CONFIG_DEBUG_RODATA) || defined(CONFIG_SET_MODULE_RONX)
> >+bool rodata_enabled __ro_after_init = true;
> >static int __init set_debug_rodata(char *str)
> >{
> >	return strtobool(str, &rodata_enabled);
> >}
> >__setup("rodata=", set_debug_rodata);
> >+#endif
> >
> >+#ifdef CONFIG_DEBUG_RODATA
> >static void mark_readonly(void)
> >{
> >	if (rodata_enabled)
> >diff --git a/kernel/module.c b/kernel/module.c
> >index f57dd63..34d1880 100644
> >--- a/kernel/module.c
> >+++ b/kernel/module.c
> >@@ -1910,6 +1910,9 @@ static void frob_writable_data(const struct module_layout *layout,
> >/* livepatching wants to disable read-only so it can frob module. */
> >void module_disable_ro(const struct module *mod)
> >{
> >+	if (!rodata_enabled)
> >+		return;
> >+
> >	frob_text(&mod->core_layout, set_memory_rw);
> >	frob_rodata(&mod->core_layout, set_memory_rw);
> >	frob_ro_after_init(&mod->core_layout, set_memory_rw);
> >@@ -1919,6 +1922,9 @@ void module_disable_ro(const struct module *mod)
> >
> >void module_enable_ro(const struct module *mod, bool after_init)
> >{
> >+	if (!rodata_enabled)
> >+		return;
> >+
> >	frob_text(&mod->core_layout, set_memory_ro);
> >	frob_rodata(&mod->core_layout, set_memory_ro);
> >	frob_text(&mod->init_layout, set_memory_ro);
> >@@ -1951,6 +1957,9 @@ void set_all_modules_text_rw(void)
> >{
> >	struct module *mod;
> >
> >+	if (!rodata_enabled)
> >+		return;
> >+
> >	mutex_lock(&module_mutex);
> >	list_for_each_entry_rcu(mod, &modules, list) {
> >		if (mod->state == MODULE_STATE_UNFORMED)
> >@@ -1967,6 +1976,9 @@ void set_all_modules_text_ro(void)
> >{
> >	struct module *mod;
> >
> >+	if (!rodata_enabled)
> >+		return;
> >+
> >	mutex_lock(&module_mutex);
> >	list_for_each_entry_rcu(mod, &modules, list) {
> >		if (mod->state == MODULE_STATE_UNFORMED)
> >@@ -1980,10 +1992,13 @@ void set_all_modules_text_ro(void)
> >
> >static void disable_ro_nx(const struct module_layout *layout)
> >{
> >-	frob_text(layout, set_memory_rw);
> >-	frob_rodata(layout, set_memory_rw);
> >+	if (rodata_enabled) {
> >+		frob_text(layout, set_memory_rw);
> >+		frob_rodata(layout, set_memory_rw);
> >+	}
> >	frob_rodata(layout, set_memory_x);
> >-	frob_ro_after_init(layout, set_memory_rw);
> >+	if (rodata_enabled)
> >+		frob_ro_after_init(layout, set_memory_rw);
> 
> Why not merge this hunk with the previous if (rodata_enabled) check?
> I think it's more readable that way. In any case, the rest of the
> patch looks good to me.

Sure. See my v3.

Thanks,
-Takahiro AKASHI

> Jessica
