Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFxSCFCoWcMapn10GyXvKpy5aMjGG+pa1P4Hu7sHqSTDKQ@mail.gmail.com>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
	<CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
	<CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
	<CA+55aFxSCFCoWcMapn10GyXvKpy5aMjGG+pa1P4Hu7sHqSTDKQ@mail.gmail.com>
Date: Wed, 13 Apr 2016 21:27:17 -0700
Message-ID: <CAGXu5jLVDJcQKpY7w1MCPW5hvjY=s+KF54aHvb8WOJycJFhF4A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on leakage in /proc/iomem file
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Emrah Demir <ed@abdsec.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Dave Jones <davej@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 6, 2016 at 2:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Apr 6, 2016 at 10:54 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> So I'd find a patch like the attached to be perfectly acceptable (in
>> fact, we should have done this long ago).
>
> I just committed it, let's see if some odd program uses the iomem
> data. I doubt it, and I always enjoy improvements that remove more
> lines of code than they add.

Hrm, it looks like at least Ubuntu's kernel security test suite
expects to find these entries (when it verifies that STRICT_DEVMEM
hasn't regressed). Also, the commit only removed the entries on x86.
Most (all?) of the other architectures still have them. Could you
revert this for now, and I'll cook up a %pK-based solution for -next?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
