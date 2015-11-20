Reply-To: kernel-hardening@lists.openwall.com
References: <CAGXu5jLE7ADT90-o-6xRA+1NGXtF3fuPnEcY2Qh6MQxaiWrHWw@mail.gmail.com>
 <56463FE5.1050500@redhat.com>
 <CAGXu5jLi=YsZNO4osWjqrJ_jLE3AQMmEKDGBCAJD7svn69Afew@mail.gmail.com>
 <564D04CC.9090902@redhat.com>
 <CAGXu5jLWnfR_a_VR_bq+vpA5NXCLafuFP-9AEVGGjr7pBpZ4XA@mail.gmail.com>
From: Jeff Law <law@redhat.com>
Message-ID: <564F55E9.2030007@redhat.com>
Date: Fri, 20 Nov 2015 10:18:33 -0700
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLWnfR_a_VR_bq+vpA5NXCLafuFP-9AEVGGjr7pBpZ4XA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: GCC upstream contacts for Linux kernel bugs
To: Kees Cook <keescook@google.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Richard Henderson <rth@redhat.com>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On 11/19/2015 11:12 AM, Kees Cook wrote:
> I remember one more that breaks the kernel's ability to do
> compile-time evaluation of target sizes, which is a useful
> vulnerability mitigation. CONFIG_DEBUG_STRICT_USER_COPY_CHECKS isn't
> useful any more since it was forced to be disabled in
> https://git.kernel.org/linus/2fb0815c9ee6
>
> original: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=48880
> duped to: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=46639
Yea, I'm already familiar with these.  46639 gets evaluated each release 
cycle as its a regression.

Essentially function splitting is setting up a situation where things 
necessary to determine a compile-time constant are in two different places.

The specific case in 46639 should be solved with the ability to run a 
minimal jump threading pass early in the optimizer pipeline.   To do 
that we need to detangle jump threading from vrp & the dominator optimizer.

The main infrastructure for that work landed a couple weeks ago.  It's 
not clear yet if the remainder of the work will slip in during the 
bugfixing phase or have to wait for gcc7.  It will largely depend on how 
much additional work needs to occur.   I don't think it's too bad, but 
I've mostly been focused on getting the infrastructure bits in place, 
rather than exploiting them at this phase.


jeff
