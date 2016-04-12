Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Tue, 12 Apr 2016 23:26:48 +0200
MIME-Version: 1.0
Message-ID: <570D6818.30507.4DB19537@pageexec.freemail.hu>
In-reply-to: <CAGXu5jLEui=E22t5=tSNG2nOA7LWO4UNuVknhteTxEZzY+iwyg@mail.gmail.com>
References: <20160407231023.5f1307ffc79f0cdd880eedb7@gmail.com>, <20160412184147.GA92432@davidb.org>, <CAGXu5jLEui=E22t5=tSNG2nOA7LWO4UNuVknhteTxEZzY+iwyg@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH v6 0/6] Introduce GCC plugin infrastructure
To: David Brown <david.brown@linaro.org>, Jeff Law <law@redhat.com>, Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <mmarek@suse.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 12 Apr 2016 at 12:46, Kees Cook wrote:

> Looks like it's in the upstream tree:
> 
> https://gcc.gnu.org/git/?p=gcc.git;a=commitdiff;h=bfe972081c3c75019fa5a6e883dcbeb5e03eea18
> 
> I'm not sure how GCC does bug fix releases. Is this going to be in 5.4
> or 5.3.1? (Is there such a thing as 5.3.1 planned?) I've CCed Jeff in
> case he's got a moment to peek at this.

gcc-5 will be maintained until gcc-7 (due in a year) so this commit will end up in
the next minor release (5.4) eventually.
