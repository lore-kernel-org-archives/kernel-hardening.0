Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFxTzWKCqYaTTLSWccriebzXSeMCkgfvf6=rckB+_jvoiw@mail.gmail.com>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
	<CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
	<CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
	<5e5e7c7ced7bede343530ed1447d7453@abdsec.com>
	<CA+55aFxTzWKCqYaTTLSWccriebzXSeMCkgfvf6=rckB+_jvoiw@mail.gmail.com>
Date: Wed, 6 Apr 2016 11:37:02 -0700
Message-ID: <CAGXu5j+gQT6pseNasW2qKSQ=wagcx06sfNqsmv5NSh8=MS4zAA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on leakage in /proc/iomem file
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Emrah Demir <ed@abdsec.com>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Dave Jones <davej@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 6, 2016 at 11:31 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Apr 6, 2016 at 11:05 AM,  <ed@abdsec.com> wrote:
>>
>> Most distros don't use KASLR, but they use kptr_restrict. Without KASLR,
>> kptr_restirct most likely useless.
>
> Well, yes kaslr is effectively useless right now due to the fact that
> people still use hibernation in effectively every single distro out
> there.

At some point I'd like to see if distros would be interested in
inverting the default logic (maybe with a CONFIG to avoid changing the
current behavior) where instead of needing to put "kaslr" on the
command line to prefer kaslr over hibernation, end users would need to
add "nokaslr" to perfer hibernation for that boot. (Bike shed config
name: CONFIG_RANDOMIZE_BASE_ENABLED.)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
