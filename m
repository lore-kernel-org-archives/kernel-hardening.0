Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 06 Apr 2016 13:05:56 -0500
From: ed@abdsec.com
In-Reply-To: <CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
 <CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
 <CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
Message-ID: <5e5e7c7ced7bede343530ed1447d7453@abdsec.com>
Subject: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on leakage in /proc/iomem file
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Rosenberg <dan.j.rosenberg@gmail.com>, Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

First, I wrote your attached patch, but then I thought zeroing other 
/proc/iomem values would be better. So I changed it.

Most distros don't use KASLR, but they use kptr_restrict. Without KASLR, 
kptr_restirct most likely useless. As you said these things should be 
done long ago


         Emrah Demir
