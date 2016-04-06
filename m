Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <1459947782-5071-1-git-send-email-ed@abdsec.com>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
Date: Wed, 6 Apr 2016 08:20:34 -0700
Message-ID: <CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on leakage in /proc/iomem file
To: Emrah Demir <ed@abdsec.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Dave Jones <davej@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 6, 2016 at 6:03 AM, Emrah Demir <ed@abdsec.com> wrote:
>
> By this patch after insertion resources, start and end address are zeroed.

I'd much rather just not insert the resources in the first place then.

         Linus
