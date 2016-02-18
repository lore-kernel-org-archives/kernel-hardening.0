Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 18 Feb 2016 22:32:17 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160218223217.301d8c7eda4f087083d97a34@gmail.com>
In-Reply-To: <CAGXu5jJyn4sxL2Rb467UyP1X1vF1ZkdBoL8GmResrNiLybztCg@mail.gmail.com>
References: <20160211233646.97c2af3675dc5b0f525f0489@gmail.com>
	<20160211234135.4478fabfc780825379936963@gmail.com>
	<CAGXu5jJyn4sxL2Rb467UyP1X1vF1ZkdBoL8GmResrNiLybztCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 2/3] Add Cyclomatic complexity GCC plugin
To: Kees Cook <keescook@chromium.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 17 Feb 2016 16:27:22 -0800
Kees Cook <keescook@chromium.org> wrote:

> It's a shame there's been so much churn with gcc's plugin API. I
> wonder if it might make sense to choose 5.0 as the supported compiler
> version for this feature, just to cut down on all the ifdef noise. For
> now, let's keep it as-is, though.

I think it is important to support all gcc versions as there are a lot of distros that
use older gcc versions than 5.

I made a pass structure generator, you can see it on my github:
https://github.com/ephox-gcc-plugins/gcc-plugins_linux-next/commits/plugins

I didn't resend the patches yet because I usually wait until there are no more comments
for the previous series.

--
Emese
