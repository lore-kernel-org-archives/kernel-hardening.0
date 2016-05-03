Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160502195617.9b2b7e07ced214a8f2136364@gmail.com>
References: <20160422201957.97ce16f0e67377d0ce613d19@gmail.com>
	<20160422202138.d50937e812b30aaba4f38a92@gmail.com>
	<CAK7LNAR-+4+Xdhbs6hoPUTYppLqFwY8dxqdSuw_5j6Pge4uYVg@mail.gmail.com>
	<20160502195617.9b2b7e07ced214a8f2136364@gmail.com>
Date: Tue, 3 May 2016 11:00:56 +0900
Message-ID: <CAK7LNATQY7AWjmEEjDFgpLPkO_oQgkNKutgGb17v7=R8RPb5zA@mail.gmail.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v7 1/6] Shared library support
To: Emese Revfy <re.emese@gmail.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Brown <david.brown@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Emese,


2016-05-03 2:56 GMT+09:00 Emese Revfy <re.emese@gmail.com>:
> On Mon, 2 May 2016 14:03:00 +0900
> Masahiro Yamada <yamada.masahiro@socionext.com> wrote:
>
>> In the first place,
>> I am wondering if we need to revive this documentation.
>> What this commit is only interested in *.so generation,
>> not host program support.
>
> I agree that we don't need this documentation. I'll remove it.
>
>> > @@ -124,5 +158,39 @@ quiet_cmd_host-cxxobjs     = HOSTCXX $@
>> >  $(host-cxxobjs): $(obj)/%.o: $(src)/%.cc FORCE
>> >         $(call if_changed_dep,host-cxxobjs)
>> >
>> > +# Compile .c file, create position independent .o file
>> > +# host-cshobjs -> .o
>> > +quiet_cmd_host-cshobjs = HOSTCC  -fPIC $@
>> > +      cmd_host-cshobjs = $(HOSTCC) $(hostc_flags) -fPIC -c -o $@ $<
>> > +$(host-cshobjs): $(obj)/%.o: $(src)/%.c FORCE
>> > +       $(call if_changed_dep,host-cshobjs)
>> > +
>> > +# Compile .c file, create position independent .o file
>>
>>
>> Please explain why c++ compiler should be used to compile .c files.
>>
>> This is not clear, so worth commenting.
>
> Where do you think that the C++ compiler is used above? I think HOSTCC can only be C compiler.
>

Not above, but *below*.

This comment "Compile .c file, create position independent .o file"
is for the following code block.


# Compile .c file, create position independent .o file
# host-cxxshobjs -> .o
quiet_cmd_host-cxxshobjs = HOSTCXX -fPIC $@
      cmd_host-cxxshobjs = $(HOSTCXX) $(hostcxx_flags) -fPIC -c -o $@ $<
                           $(host-cxxshobjs): $(obj)/%.o: $(src)/%.c FORCE
                           $(call if_changed_dep,host-cxxshobjs)




We generally use HOSTCC to compile *.c files,
and HOSTCXX to compile *.cc files.


But, here, you mention to use HOSTCXX to compile .c files
such as cyc_complexity_plugin.c, sancov_plugin.c, etc.

This is not straight-forward.  It is worthwhile to comment the reason.


-- 
Best Regards
Masahiro Yamada
