Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jLN5NLH+ScR_i+C18EXqektP92vCrb2h8K_pvR0Yb1bYg@mail.gmail.com>
References: <1477071466-19256-1-git-send-email-michael.leibowitz@intel.com> <CAGXu5jLN5NLH+ScR_i+C18EXqektP92vCrb2h8K_pvR0Yb1bYg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 27 Oct 2016 23:01:46 -0700
Message-ID: <CAGXu5jLCCUK0AWBf4V-Djqydd3y3JxT5ccLmg8ATwn7_1-DTaQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] Add the randstruct gcc plugin
To: Michael Leibowitz <michael.leibowitz@intel.com>
Cc: Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>, "Schaufler, Casey" <casey.schaufler@intel.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 27, 2016 at 9:09 PM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Oct 21, 2016 at 10:37 AM, Michael Leibowitz
> <michael.leibowitz@intel.com> wrote:
>> This plugin randomizes the layout of certain structures at compile
>> time.  This introduces two defines __randomize_layout and
>> __no_randomize_layout.  Which, in turn, tell the compiler to either
>> try to randomize or not to randomize the struct in question.
>>
>> This feature is ported over from grsecurity.  The implementation is
>> nearly identical to the original code written by the PaX Team and
>> Spender.  To make integration simpler, this version only supports
>> explicit marking of structures.  However, it retains the
>> __no_randomize_layout support for the future.  The UAPI checks are
>> retained as well.  Structures that are to be randomized are required
>> to use the C99 designated initializer form.
>>
>> Signed-off-by: Michael Leibowitz <michael.leibowitz@intel.com>
>> [...]
>> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
>> index 61f0e6d..94bfffe 100644
>> --- a/scripts/Makefile.gcc-plugins
>> +++ b/scripts/Makefile.gcc-plugins
>> @@ -19,9 +19,19 @@ ifdef CONFIG_GCC_PLUGINS
>>      endif
>>    endif
>>
>> -  GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
>> +  RANDSTRUCT_PLUGIN := -fplugin=$(objtree)/scripts/gcc-plugins/randomize_layout_plugin.so
>> +  ifdef CONFIG_GCC_PLUGIN_RANDSTRUCT
>> +    gcc-plugin-$(CONFIG_GCC_PLUGIN_RANDSTRUCT)         += randomize_layout_plugin.so
>>
>> -  export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR SANCOV_PLUGIN
>> +    GCC_PLUGIN_RANDSTRUCT_CFLAGS := -fplugin=$(objtree)/scripts/gcc-plugins/randomize_layout_plugin.so -DRANDSTRUCT_PLUGIN
>> +    ifdef CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE
>> +      GCC_PLUGIN_RANDSTRUCT_CFLAGS = -fplugin-arg-randomize_layout_plugin-performance-mode
>
> Found it: this "=" should be "+=", though really the whole section
> should just be updated to the new style of plugin handling:
>
>   gcc-plugin-$(CONFIG_GCC_PLUGIN_RANDSTRUCT)    += randomize_layout_plugin.so
>   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_RANDSTRUCT)     += -DRANDSTRUCT_PLUGIN
>   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE) +=
> -fplugin-arg-randomize_layout_plugin-performance-mode
>
> and the export of RANDSTRUCT_PLUGIN

Also, it looks like "pahole" (or the DWARF record) is lying. :P
Printing out offsetof()s shows things clearly randomized.

For the next version: can you update to the latest version of this
plugin? What you sent seems out of date compared to current
grsecurity. Disabling is_pure_ops_struct() with a "return 0" looks to
be sufficient to stop the automatic randomization.

-Kees

-- 
Kees Cook
Nexus Security
