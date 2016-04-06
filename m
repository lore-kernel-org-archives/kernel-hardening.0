Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <5e5e7c7ced7bede343530ed1447d7453@abdsec.com>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
	<CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
	<CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
	<5e5e7c7ced7bede343530ed1447d7453@abdsec.com>
Date: Wed, 6 Apr 2016 11:31:50 -0700
Message-ID: <CA+55aFxTzWKCqYaTTLSWccriebzXSeMCkgfvf6=rckB+_jvoiw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on leakage in /proc/iomem file
To: Emrah Demir <ed@abdsec.com>
Cc: Dan Rosenberg <dan.j.rosenberg@gmail.com>, Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 6, 2016 at 11:05 AM,  <ed@abdsec.com> wrote:
>
> Most distros don't use KASLR, but they use kptr_restrict. Without KASLR,
> kptr_restirct most likely useless.

Well, yes kaslr is effectively useless right now due to the fact that
people still use hibernation in effectively every single distro out
there.

But kptr_restrict was enabled by distro people, and in theory it does
end up possibly helping: it at least it hides the exact per-function
addresses.

Of course, with 99.9% of all users then using a distro kernel, you can
just get those remotely anyway by just downloading the distro image,
so it turns out that now there is effectively zero bits that you are
really hiding, because the information is effectively right there in
"uname -a".

End result: kptr_restrict is a wonderful flag if all you want to
disable is a trivial convenience function that is easy for an attacker
to do other ways.

Quite frankly, personally I find a lot of security people and patches
to be disingenuous for exactly this kind of reason. They look at the
small details, and are completely missing the big picture.

I'm at the IoT conference right now. "Security" has been a big word
this week. "45 billion devices, lack of security, the sky is falling".
I don't think we had a lot of people talking about "oh, the cloud
service is getting shut down, so now those devices don't even *work*".

But that's ok. Because "security" is more important than "reality". Groan.

                Linus
