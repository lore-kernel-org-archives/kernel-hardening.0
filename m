Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 25 Feb 2016 23:45:42 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160225234542.3c02b799b9715fdbd3e9de93@gmail.com>
In-Reply-To: <CAGXu5jL0-Kq=paYLsq5KC+cKL1-1U=b_CBLuKQr_KtwG2fqdLg@mail.gmail.com>
References: <20160222201335.449323716ca4d929f92424d5@gmail.com>
	<CAGXu5jL0-Kq=paYLsq5KC+cKL1-1U=b_CBLuKQr_KtwG2fqdLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 0/3] Introduce GCC plugin infrastructure
To: Kees Cook <keescook@chromium.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 22 Feb 2016 16:20:40 -0800
Kees Cook <keescook@chromium.org> wrote:
> Running each patch through scripts/checkpatch.pl produces a number of
> other warnings (I ignored all the C++isms), mostly around lines >80
> characters, function definitions (missing void), and the suggestion to

I fixed only those >80 line type warnings that didn't impair the readability of the code:
https://github.com/ephox-gcc-plugins/gcc-plugins_linux-next/commit/77c8e286fb

-- 
Emese
