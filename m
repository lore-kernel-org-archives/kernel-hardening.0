Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAEXv5_hcqjdbSKArKRgbqr_A=AR6E0H1Zg3GgL8UGQezg0GeKg@mail.gmail.com>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
	<n1iirh$q7o$1@ger.gmane.org>
	<CAGXu5j+ponF+a3aoCnLqEVfBy545BsxT4w=8KGikNCb_24ZgyQ@mail.gmail.com>
	<n1khkt$lc7$1@ger.gmane.org>
	<CAGXu5jLuEBUYFNmWOVNvMnTbwyy_+0R1_SywBVhcxkCcm83e-g@mail.gmail.com>
	<26467.1447105487@turing-police.cc.vt.edu>
	<CAEXv5_hcqjdbSKArKRgbqr_A=AR6E0H1Zg3GgL8UGQezg0GeKg@mail.gmail.com>
Date: Mon, 9 Nov 2015 15:35:53 -0800
Message-ID: <CAGXu5jKf5iA63r0euOmgBBBoTBV-4LYTZPLQSY5oD4Uhzu=x8w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: Kernel Self Protection Project
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 9, 2015 at 1:55 PM, David Windsor <dave@0x4141.net> wrote:
>
> On Mon, Nov 9, 2015 at 4:44 PM, <Valdis.Kletnieks@vt.edu> wrote:
>>
>> On Sat, 07 Nov 2015 22:50:04 -0800, Kees Cook said:
>>
>> > Yeah. Does anyone want to also extract PAX_USERCOPY or
>> > GRKERNSEC_KSTACKOVERFLOW ? No one has mentioned an interest in those
>> > yet.
>>
>> I'll commit to at least looking at PAX_USERCOPY.  Looks reasonably
>> stand-alone.
>
> The problem is cherrypicking these things from the original patchsets.  I'm
> doing that now for PAX_REFCOUNT, and it's proving more difficult than I
> originally expected.

Yes! Things are rather intertwined. :)

-Kees

-- 
Kees Cook
Chrome OS Security
