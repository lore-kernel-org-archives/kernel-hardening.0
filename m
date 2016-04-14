Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 14 Apr 2016 03:39:05 -0400
From: Emrah Demir <ed@abdsec.com>
In-Reply-To: <CAGXu5jLVDJcQKpY7w1MCPW5hvjY=s+KF54aHvb8WOJycJFhF4A@mail.gmail.com>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
 <CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
 <CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
 <CA+55aFxSCFCoWcMapn10GyXvKpy5aMjGG+pa1P4Hu7sHqSTDKQ@mail.gmail.com>
 <CAGXu5jLVDJcQKpY7w1MCPW5hvjY=s+KF54aHvb8WOJycJFhF4A@mail.gmail.com>
Message-ID: <f8e523a05927eef49a9a3566d176aa62@abdsec.com>
Subject: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on leakage in /proc/iomem file
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, kernel-hardening@lists.openwall.com, Dave Jones <davej@redhat.com>, keescook@google.com
List-ID: <kernel-hardening.lists.openwall.com>

On 2016-04-14 00:27, Kees Cook wrote:
> On Wed, Apr 6, 2016 at 2:19 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Wed, Apr 6, 2016 at 10:54 AM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> 
>>> So I'd find a patch like the attached to be perfectly acceptable (in
>>> fact, we should have done this long ago).
>> 
>> I just committed it, let's see if some odd program uses the iomem
>> data. I doubt it, and I always enjoy improvements that remove more
>> lines of code than they add.
> 
> Hrm, it looks like at least Ubuntu's kernel security test suite
> expects to find these entries (when it verifies that STRICT_DEVMEM
> hasn't regressed). Also, the commit only removed the entries on x86.
> Most (all?) of the other architectures still have them. Could you
> revert this for now, and I'll cook up a %pK-based solution for -next?
> 

Actually, I have realized that this patch (Linus's patch) was for x86. I 
was planning to code the same for other architectures.
It seems your method is better. %pK will zero other values in 
/proc/iomem.

Perhaps Ubuntu patch might be a good option.
