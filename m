Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 16 Jan 2017 12:26:22 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170116122622.GF5908@leverpostej>
References: <20170113220256.GA57663@beast>
 <20170116115435.GB5908@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170116115435.GB5908@leverpostej>
Subject: Re: [kernel-hardening] Re: [PATCH] gcc-plugins: Add structleak for
 more stack initialization
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, park jinbum <jinb.park7@gmail.com>, Daniel Micay <danielmicay@gmail.com>, linux-kernel@vger.kernel.org, dave.martin@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 16, 2017 at 11:54:35AM +0000, Mark Rutland wrote:
> Hi,
> 
> [adding Dave, so retaining full context below]
> 
> On Fri, Jan 13, 2017 at 02:02:56PM -0800, Kees Cook wrote:
> > This plugin detects any structures that contain __user attributes and
> > makes sure it is being fulling initialized so that a specific class of
> 
> Nit: s/fulling/fully/
> 
> > information exposure is eliminated. (For example, the exposure of siginfo
> > in CVE-2013-2141 would have been blocked by this plugin.)
> > 
> > Ported from grsecurity/PaX. This version adds a verbose option to the
> > plugin and the Kconfig.
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  arch/Kconfig                            |  22 +++
> >  include/linux/compiler.h                |   6 +-
> >  scripts/Makefile.gcc-plugins            |   4 +
> >  scripts/gcc-plugins/structleak_plugin.c | 246 ++++++++++++++++++++++++++++++++
> >  4 files changed, 277 insertions(+), 1 deletion(-)
> >  create mode 100644 scripts/gcc-plugins/structleak_plugin.c
> 
> I tried giving this a go, but I got the build failure below:

Looking again, I see that there was another patch to add PASS_INFO() and
other bits that the patch required. Sorry for the noise there.

In the mean time, I cribbed from the latent entropy plugin, and built
with the below applied:

----
diff --git a/scripts/gcc-plugins/structleak_plugin.c b/scripts/gcc-plugins/structleak_plugin.c
index deddb72..1e01763 100644
--- a/scripts/gcc-plugins/structleak_plugin.c
+++ b/scripts/gcc-plugins/structleak_plugin.c
@@ -210,8 +210,12 @@ __visible int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gc
        const int argc = plugin_info->argc;
        const struct plugin_argument * const argv = plugin_info->argv;
        bool enable = true;
-
-       PASS_INFO(structleak, "early_optimizations", 1, PASS_POS_INSERT_BEFORE);
+       struct register_pass_info structleak_pass_info = {
+               .pass  = make_structleak_pass(),
+               .reference_pass_name = "early_optimizations",
+               .ref_pass_instance_number = 1,
+               .pos_op = PASS_POS_INSERT_BEFORE,
+       };
 
        if (!plugin_default_version_check(version, &gcc_version)) {
                error(G_("incompatible gcc/plugin versions"));
----

With verbose mode, I see quite a few initializations, mostly in signal
handling. Something to add to the queue of things to investigate...

Mark.
