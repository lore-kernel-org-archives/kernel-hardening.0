Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160502195617.9b2b7e07ced214a8f2136364@gmail.com>
References: <20160422201957.97ce16f0e67377d0ce613d19@gmail.com>
	<20160422202138.d50937e812b30aaba4f38a92@gmail.com>
	<CAK7LNAR-+4+Xdhbs6hoPUTYppLqFwY8dxqdSuw_5j6Pge4uYVg@mail.gmail.com>
	<20160502195617.9b2b7e07ced214a8f2136364@gmail.com>
Date: Tue, 3 May 2016 11:06:02 +0900
Message-ID: <CAK7LNASF_0eWJqC6ugFf4hRAw0pe1HuRAWaOF8M_nWXCKmQAOQ@mail.gmail.com>
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

OK.
Also, rephrase the git-log of this patch.

This patch is almost your original code,
not reverting 62e2210798ed38928ab24841e8b4878a.



-- 
Best Regards
Masahiro Yamada
