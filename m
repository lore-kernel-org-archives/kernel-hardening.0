Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 28 Jun 2016 13:39:42 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160628133942.3ef9ea556a38f98a4c5dcd05@gmail.com>
In-Reply-To: <CAGXu5jJw-HcYRo8muSQ7Av9ZGuO3jTgV2x_xDcqmK-i=2nu1aw@mail.gmail.com>
References: <20160626173451.c8406cd0c7a87cc3f94d9753@gmail.com>
	<CAGXu5jJw-HcYRo8muSQ7Av9ZGuO3jTgV2x_xDcqmK-i=2nu1aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] powerpc/kernel: Disable the latent entropy plugin
 unconditionally
To: Kees Cook <keescook@chromium.org>
Cc: Michal Marek <mmarek@suse.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 27 Jun 2016 09:05:08 -0700
Kees Cook <keescook@chromium.org> wrote:

> On Sun, Jun 26, 2016 at 8:34 AM, Emese Revfy <re.emese@gmail.com> wrote:
> >
> > Reported-by: PaX Team <pageexec@freemail.hu>
> > Signed-off-by: Emese Revfy <re.emese@gmail.com>
> 
> Thanks! Can you include a body in the commit message? For this, something like:
> 
> Disable the gcc-plugin unconditionlly here because ... *reason it is required*

Hi,

You can see it here:
https://github.com/ephox-gcc-plugins/gcc-plugins_linux-next/commit/a1bb2bd3fd9ac414623ec3210e9c514d9d38cf9e

-- 
Emese
