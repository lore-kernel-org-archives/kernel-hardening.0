Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 13 Jun 2016 02:18:31 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160613021831.9a79c5c82d1511e572023ed6@gmail.com>
In-Reply-To: <CAGXu5jJ_+azG6H0tB7W0mJTUzXp18Y7qN7dx7EEKng+0nO-dig@mail.gmail.com>
References: <20160611161212.GA29370@www.outflux.net>
	<20160611162926.GL12567@windriver.com>
	<20160613001244.b4b3c675d59e3ad3d8d656a4@gmail.com>
	<CAGXu5jJ_+azG6H0tB7W0mJTUzXp18Y7qN7dx7EEKng+0nO-dig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: disable under COMPILE_TEST
To: Kees Cook <keescook@chromium.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, Michal Marek <mmarek@suse.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Linux-Next <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 12 Jun 2016 15:25:39 -0700
Kees Cook <keescook@chromium.org> wrote:

> I don't like this because it means if someone specifically selects
> some plugins in their .config, and the headers are missing, the kernel
> will successfully compile. For many plugins, this results in a kernel
> that lacks the requested security features, and that I really do not
> want to have happening. I'm okay leaving these disabled for compile
> tests for now. We can revisit this once more distros have plugins
> enabled by default.

You are right. Your patch is safer.

-- 
Emese
