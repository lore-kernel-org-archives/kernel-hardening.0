Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFxSCFCoWcMapn10GyXvKpy5aMjGG+pa1P4Hu7sHqSTDKQ@mail.gmail.com>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
	<CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
	<CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
	<CA+55aFxSCFCoWcMapn10GyXvKpy5aMjGG+pa1P4Hu7sHqSTDKQ@mail.gmail.com>
Date: Wed, 6 Apr 2016 14:27:38 -0700
Message-ID: <CAGXu5j+TAncQVkW6ArfL6CfT_LCHVE-HUtW+0kq3+FK+1rK_Qg@mail.gmail.com>
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

Hrm, okay. I still think just changing the perms would be less
troublesome. Knowing where the kernel is in physical memory when
debugging physical memory issues seems important to me. But, I have
never actually used it since I prefer looking in kallsyms. :)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
