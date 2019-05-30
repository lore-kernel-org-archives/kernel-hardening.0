MIME-Version: 1.0
References: <20190530170033.GA5739@cisco>
In-Reply-To: <20190530170033.GA5739@cisco>
From: Andrew Pinski <pinskia@gmail.com>
Date: Thu, 30 May 2019 10:09:44 -0700
Message-ID: <CA+=Sn1kSg-Y8SseUWPTTJi5HRgYYxVtcDGUJvCcCYQQzKeiUQw@mail.gmail.com>
Subject: Re: unrecognizable insn generated in plugin?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Tycho Andersen <tycho@tycho.ws>
Cc: GCC Mailing List <gcc@gcc.gnu.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 30, 2019 at 10:01 AM Tycho Andersen <tycho@tycho.ws> wrote:
>
> Hi all,
>
> I've been trying to implement an idea Andy suggested recently for
> preventing some kinds of ROP attacks. The discussion of the idea is
> here:
> https://lore.kernel.org/linux-mm/DFA69954-3F0F-4B79-A9B5-893D33D87E51@ama=
capital.net/
>
> Right now I'm struggling to get my plugin to compile without crashing. Th=
e
> basic idea is to insert some code before every "pop rbp" and "pop rsp"; I=
've
> figured out how to find these instructions, and I'm inserting code using:
>
> emit_insn(gen_rtx_XOR(DImode, gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGN=
UM),
>                       gen_rtx_MEM(DImode, gen_rtx_REG(DImode, HARD_FRAME_=
POINTER_REGNUM))));

Simplely this xor does not set anything.
I think you want something like:
emit_insn(gen_rtx_SET(gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM),
  gen_rtx_XOR(DImode, gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM),
      gen_rtx_MEM(DImode, gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM))))=
);

But that might not work either, you might need some thing more.

Thanks,
Andrew Pinski

>
> The plugin completes successfully, but GCC complains later,
>
> kernel/seccomp.c: In function =E2=80=98seccomp_check_filter=E2=80=99:
> kernel/seccomp.c:242:1: error: unrecognizable insn:
>  }
>  ^
> (insn 698 645 699 17 (xor:DI (reg:DI 6 bp)
>         (mem:DI (reg:DI 6 bp) [0  S8 A8])) "kernel/seccomp.c":242 -1
>      (nil))
> during RTL pass: shorten
> kernel/seccomp.c:242:1: internal compiler error: in insn_min_length, at c=
onfig/i386/i386.md:14714
>
> I assume this is because some internal metadata is screwed up, but I have=
 no
> clue as to what that is or how to fix it. My gcc version is 8.3.0, and
> config/i386/i386.md:14714 of that tag looks mostly unrelated.
>
> I had problems earlier because I was trying to run it after *clean_state =
which
> is the thing that does init_insn_lengths(), but now I'm running it after
> *stack_regs, so I thought it should be ok...
>
> Anyway, the full plugin draft is below. You can run it by adding
> CONFIG_GCC_PLUGIN_HEAPLEAP=3Dy to your kernel config.
>
> Thanks!
>
> Tycho
>
>
> From 83b0631f14784ce11362ebd64e40c8d25c0decee Mon Sep 17 00:00:00 2001
> From: Tycho Andersen <tycho@tycho.ws>
> Date: Fri, 19 Apr 2019 19:24:58 -0600
> Subject: [PATCH] heapleap
>
> Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> ---
>  scripts/Makefile.gcc-plugins          |   8 ++
>  scripts/gcc-plugins/Kconfig           |   4 +
>  scripts/gcc-plugins/heapleap_plugin.c | 189 ++++++++++++++++++++++++++
>  3 files changed, 201 insertions(+)
>
> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
> index 5f7df50cfe7a..283b81dc5742 100644
> --- a/scripts/Makefile.gcc-plugins
> +++ b/scripts/Makefile.gcc-plugins
> @@ -44,6 +44,14 @@ ifdef CONFIG_GCC_PLUGIN_ARM_SSP_PER_TASK
>  endif
>  export DISABLE_ARM_SSP_PER_TASK_PLUGIN
>
> +gcc-plugin-$(CONFIG_GCC_PLUGIN_HEAPLEAP)       +=3D heapleap_plugin.so
> +gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_HEAPLEAP)                \
> +                       +=3D -DHEAPLEAP_PLUGIN
> +ifdef CONFIG_GCC_PLUGIN_HEAPLEAP
> +    DISABLE_HEAPLEAP_PLUGIN +=3D -fplugin-arg-heapleap_plugin-disable
> +endif
> +export DISABLE_HEAPLEAP_PLUGIN
> +
>  # All the plugin CFLAGS are collected here in case a build target needs =
to
>  # filter them out of the KBUILD_CFLAGS.
>  GCC_PLUGINS_CFLAGS :=3D $(strip $(addprefix -fplugin=3D$(objtree)/script=
s/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
> diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
> index 74271dba4f94..491b9cd5df1a 100644
> --- a/scripts/gcc-plugins/Kconfig
> +++ b/scripts/gcc-plugins/Kconfig
> @@ -226,4 +226,8 @@ config GCC_PLUGIN_ARM_SSP_PER_TASK
>         bool
>         depends on GCC_PLUGINS && ARM
>
> +config GCC_PLUGIN_HEAPLEAP
> +       bool "Prevent 'pop esp' type instructions from loading an address=
 in the heap"
> +       depends on GCC_PLUGINS
> +
>  endif
> diff --git a/scripts/gcc-plugins/heapleap_plugin.c b/scripts/gcc-plugins/=
heapleap_plugin.c
> new file mode 100644
> index 000000000000..5051b96d79f4
> --- /dev/null
> +++ b/scripts/gcc-plugins/heapleap_plugin.c
> @@ -0,0 +1,189 @@
> +/*
> + * This is based on an idea from Andy Lutomirski described here:
> + * https://lore.kernel.org/linux-mm/DFA69954-3F0F-4B79-A9B5-893D33D87E51=
@amacapital.net/
> + *
> + * unsigned long offset =3D *rsp - rsp;
> + * offset >>=3D THREAD_SHIFT;
> + * if (unlikely(offset))
> + *     BUG();
> + * POP RSP;
> + */
> +
> +#include "gcc-common.h"
> +
> +__visible int plugin_is_GPL_compatible;
> +static bool disable =3D false;
> +
> +static struct plugin_info heapleap_plugin_info =3D {
> +       .version =3D "1",
> +       .help =3D "disable\t\tdo not activate the plugin\n"
> +};
> +
> +static bool heapleap_gate(void)
> +{
> +       tree section;
> +
> +       /*
> +        * Similar to stackleak, we only do this for user code for now.
> +        */
> +       section =3D lookup_attribute("section",
> +                                  DECL_ATTRIBUTES(current_function_decl)=
);
> +       if (section && TREE_VALUE(section)) {
> +               section =3D TREE_VALUE(TREE_VALUE(section));
> +
> +               if (!strncmp(TREE_STRING_POINTER(section), ".init.text", =
10))
> +                       return false;
> +               if (!strncmp(TREE_STRING_POINTER(section), ".devinit.text=
", 13))
> +                       return false;
> +               if (!strncmp(TREE_STRING_POINTER(section), ".cpuinit.text=
", 13))
> +                       return false;
> +               if (!strncmp(TREE_STRING_POINTER(section), ".meminit.text=
", 13))
> +                       return false;
> +       }
> +
> +       return !disable;
> +}
> +
> +/*
> + * Check that:
> + *
> + * unsigned long offset =3D *rbp - rbp;
> + * offset >>=3D THREAD_SHIFT;
> + * if (unlikely(offset))
> + *     BUG();
> + * pop rbp;
> + *
> + * (we should probably do the same for rsp?)
> + */
> +static void heapleap_add_check(rtx_insn *insn)
> +{
> +       rtx_insn *seq_head;
> +
> +       fprintf(stderr, "adding heapleap check\n");
> +       print_rtl_single(stderr, insn);
> +
> +       start_sequence();
> +
> +       /* xor ebp [ebp] */
> +       emit_insn(gen_rtx_XOR(DImode, gen_rtx_REG(DImode, HARD_FRAME_POIN=
TER_REGNUM),
> +                             gen_rtx_MEM(DImode, gen_rtx_REG(DImode, HAR=
D_FRAME_POINTER_REGNUM))));
> +
> +       /* ebp >> THREAD_SHIFT */
> +       /*
> +        * TODO: THREAD_SHIFT isn't defined for every arch, including x86=
.
> +        * THREAD_SIZE for x86_64 is 4096 * 2, so THREAD_SHIFT would be 1=
3
> +        * there. We should at least compute this from THREAD_SIZE though=
.
> +        */
> +       emit_insn(gen_rtx_LSHIFTRT(DImode, gen_rtx_REG(DImode, HARD_FRAME=
_POINTER_REGNUM),
> +                                  GEN_INT(13)));
> +
> +       /*
> +        * We're inserting right before the final pass, and we're adding =
some
> +        * kind of jump, thus splitting the basic block that is the epilo=
gue.
> +        * That probably causes problems, and currently gcc crashes when =
doing
> +        * the final pass after we emit this, so we probably need to do b=
etter.
> +        */
> +       emit_insn(gen_rtx_IF_THEN_ELSE(DImode,
> +                       gen_rtx_NE(DImode,
> +                               gen_rtx_REG(DImode, HARD_FRAME_POINTER_RE=
GNUM),
> +                               GEN_INT(0)),
> +                       /*
> +                        * we're really not supposed to BUG() for this st=
uff;
> +                        * maybe we should figure out how to call WARN()?=
 might
> +                        * be painful.
> +                        */
> +                       gen_ud2(),
> +                       /* poor man's no-op, i.e. how do i do this better=
? */
> +                       gen_rtx_SET(gen_rtx_REG(DImode, HARD_FRAME_POINTE=
R_REGNUM),
> +                                   gen_rtx_REG(DImode, HARD_FRAME_POINTE=
R_REGNUM))));
> +       seq_head =3D get_insns();
> +       end_sequence();
> +
> +       emit_insn_before(seq_head, insn);
> +}
> +
> +static unsigned int heapleap_execute(void)
> +{
> +       rtx_insn *insn, *next;
> +
> +       if (strcmp(IDENTIFIER_POINTER(DECL_NAME(cfun->decl)), "seccomp_ch=
eck_filter"))
> +               return 0;
> +
> +       for (insn =3D get_insns(); insn; insn =3D next) {
> +               rtx body, set, lhs, rhs;
> +               int i;
> +
> +               next =3D NEXT_INSN(insn);
> +               if (!next)
> +                       continue;
> +
> +               if (!RTX_FRAME_RELATED_P(next) || !NONJUMP_INSN_P(next))
> +                       continue;
> +
> +               /*
> +                * I don't understand why we need this; but PATTERN(insn)=
 is a
> +                * CODE_LABEL, so...
> +                */
> +               body =3D XEXP(insn, 1);
> +               set =3D PATTERN(body);
> +               if (GET_CODE(set) !=3D SET)
> +                       continue;
> +
> +               /* TODO: use SET_DEST() here instead? */
> +               lhs =3D XEXP(set, 0);
> +               /* TODO: ebp vs esp? esp only occurs twice in my linked k=
ernel */
> +               if (GET_CODE(lhs) !=3D REG || REGNO(lhs) !=3D HARD_FRAME_=
POINTER_REGNUM)
> +                       continue;
> +
> +               /* TODO: use SET_SRC() here instead? */
> +               rhs =3D XEXP(set, 1);
> +               if (GET_CODE(rhs) !=3D MEM)
> +                       continue;
> +
> +               heapleap_add_check(next);
> +       }
> +
> +       return 0;
> +}
> +
> +#define PASS_NAME heapleap
> +#include "gcc-generate-rtl-pass.h"
> +
> +__visible int plugin_init(struct plugin_name_args *plugin_info,
> +                         struct plugin_gcc_version *version)
> +{
> +       const char * const plugin_name =3D plugin_info->base_name;
> +       const int argc =3D plugin_info->argc;
> +       const struct plugin_argument * const argv =3D plugin_info->argv;
> +       int i;
> +
> +       /*
> +        * *clean_state is the pass that does init_insn_lengths(), so we =
can't
> +        * do anything after this, because gcc fails there's not a length=
 for
> +        * every instruction in the final pass
> +        */
> +       PASS_INFO(heapleap, "*stack_regs", 1, PASS_POS_INSERT_AFTER);
> +
> +       if (!plugin_default_version_check(version, &gcc_version)) {
> +               error(G_("incompatible gcc/plugin versions"));
> +               return 1;
> +       }
> +
> +       for (i =3D 0; i < argc; i++) {
> +               if (!strcmp(argv[i].key, "disable")) {
> +                       disable =3D true;
> +                       return 0;
> +               } else {
> +                       error(G_("unknown option '-fplugin-arg-%s-%s'"),
> +                                       plugin_name, argv[i].key);
> +                       return 1;
> +               }
> +       }
> +
> +       register_callback(plugin_name, PLUGIN_INFO, NULL,
> +                                               &heapleap_plugin_info);
> +
> +       register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL,
> +                                       &heapleap_pass_info);
> +       return 0;
> +}
> --
> 2.20.1
>
