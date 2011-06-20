Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4DFF7A59.40200@redhat.com>
Date: Mon, 20 Jun 2011 12:50:33 -0400
From: Eric Paris <eparis@redhat.com>
MIME-Version: 1.0
References: <20110617171152.GA1389@albatros> <4DFF5795.9080609@redhat.com> <20110620150001.GF12469@mail.hallyn.com>
In-Reply-To: <20110620150001.GF12469@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC v2] security: intoduce ptrace_task_may_access_current
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>, John Johansen <john.johansen@canonical.com>, kernel-hardening@lists.openwall.com, serge@hallyn.com
List-ID: <kernel-hardening.lists.openwall.com>

On 06/20/2011 11:00 AM, Serge Hallyn wrote:
> Quoting Eric Paris (eparis@redhat.com):
>> Ahhhh, I feel so unhappy with capability code these days.  Serge can
>> you come to the rescue?  I'm really really starting to dislike the
>> fact that we have lots of code flows that goes
>> kernel->kernel/capablities->LSM->security/capabilities.  Which is a
>> very strange calling convention.  I'd like to stop adding any calls
>> to kernel/capability.c and everything from now on needs to be done
>> with an LSM function named security_*.  I'd really like to see
>> kernel/capabilities stripped back to nothing but syscall handling
>> and move all of has_capability, has_ns_capability, ns_capable,
>> task_ns_capable, and all that crap moved to normal LSM calls.
> 
> I can see why you'd feel that way, but I'd like to hold off on that
> until we get targeted capabilities and VFS user namespace support ironed
> out.  I'm working on it right now (at
> http://kernel.ubuntu.com/git?p=serge/userns-2.6.git;a=summary)
> 
> I certainly do not want the targeted stuff duplicated in every LSM.
> Maybe we can move that stuff into security/security.c though.
> 
> Anyway I'm just coming back after leave, and only ever took a
> quick glance at this patch.  I'll look again.

I'm certainly not asking for you to throw down everything you have to do
and rewrite all of this code!  But I'd like to see a slow move towards
the elimination of kernel/capability.c and wondered if you agreed that
was a good idea.  If so, this can be the first place we start to think
about how to move intelligently to use LSM functions rather than direct
capability calls.  I like the idea that he use the has_* functions
instead of creating new ones in there.

Hopefully you can help guide us on the right path Serge!

-Eric
