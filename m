Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <alpine.DEB.2.20.10.1604061152180.13127@trent.utfs.org>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
	<CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
	<CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
	<5e5e7c7ced7bede343530ed1447d7453@abdsec.com>
	<alpine.DEB.2.20.10.1604061152180.13127@trent.utfs.org>
Date: Wed, 6 Apr 2016 11:53:59 -0700
Message-ID: <CAGXu5jL33J37n4WmC5Kq1-ja1DbTOOmk1D7j4dJ7DRq1keRKNA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on leakage in /proc/iomem file
To: Christian Kujau <lists@nerdbynature.de>
Cc: Emrah Demir <ed@abdsec.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Dave Jones <davej@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 6, 2016 at 11:52 AM, Christian Kujau <lists@nerdbynature.de> wrote:
> On Wed, 6 Apr 2016, ed@abdsec.com wrote:
>> First, I wrote your attached patch, but then I thought zeroing other
>> /proc/iomem values would be better. So I changed it.
>
> On my systems, /proc/iomem, /proc/ioports and others get their
> world-readable bits removed during bootup - I guess that would mitigate
> this issue too?

Yeah, I think that'd be sufficient (that's the first patch I
suggested). It's not a strong as kptr_restrict since kptr_restrict has
mode "2", but ... I think that's some diminishing returns...

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
