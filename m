Date: Wed, 19 Apr 2017 21:18:13 +1000 (AEST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <20170419034526.18565-1-matt@nmatt.com>
Message-ID: <alpine.LRH.2.20.1704192114270.12914@namei.org>
References: <20170419034526.18565-1-matt@nmatt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH] make TIOCSTI ioctl require CAP_SYS_ADMIN
To: Matt Brown <matt@nmatt.com>
Cc: serge@hallyn.com, gregkh@linuxfoundation.org, jslaby@suse.com, akpm@linux-foundation.org, jannh@google.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 18 Apr 2017, Matt Brown wrote:

> This patch reproduces GRKERNSEC_HARDEN_TTY functionality from the grsecurity
> project in-kernel.

It seems like an ugly hack to an ugly feature (CAP_SYS_ADMIN barely makes 
sense here), and rather than sprinkling these types of things throughout 
the kernel, I wonder if it might be better to implement it via LSM, in the 
YAMA module.



- James
-- 
James Morris
<jmorris@namei.org>
