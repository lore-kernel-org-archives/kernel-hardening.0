Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160412205209.1b7f4b610674d22ac3e59f00@gmail.com>
References: <20160407231023.5f1307ffc79f0cdd880eedb7@gmail.com>
	<20160412174607.GA92143@davidb.org>
	<CAGXu5jKPqkG52ckYAJPscySfyg+YHEVsMvPq-05YM4A3Ypx4Kg@mail.gmail.com>
	<20160412205209.1b7f4b610674d22ac3e59f00@gmail.com>
Date: Tue, 12 Apr 2016 12:47:37 -0700
Message-ID: <CAGXu5j+Sw6fKU4VgU6ancEqnqQfJuf_YDuPt4UWwE8ou1t8KMw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v6 0/6] Introduce GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>
Cc: David Brown <david.brown@linaro.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <mmarek@suse.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 12, 2016 at 11:52 AM, Emese Revfy <re.emese@gmail.com> wrote:
> On Tue, 12 Apr 2016 11:27:52 -0700
> Kees Cook <keescook@chromium.org> wrote:
>
>> Emese, were you thinking of doing the initify plugin next after this
>> infrastructure lands?
>
> I already started to work on the entropy plugin but after that I can work on initify.

Ah yes, thanks! I'd forgotten you'd mentioned the entropy plugin
previously. Great!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
