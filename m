Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <506B19D5.80803@linux.vnet.ibm.com>
References: <5064A862.20708@linux.vnet.ibm.com>
	<CAGXu5j+Ysx+i+crdNbJjiCekuRMZT-RPW3gOHzA9Gh8q7dpWeA@mail.gmail.com>
	<506B19D5.80803@linux.vnet.ibm.com>
Date: Tue, 2 Oct 2012 15:17:29 -0700
Message-ID: <CAGXu5jK-=EZ8tmkTZ8eESAFjt9OJoPOOcKTXfmREy4ZMuB13SQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: Linux Security Workgroup
To: Corey Bryant <coreyb@linux.vnet.ibm.com>, Julia Lawall <julia.lawall@lip6.fr>
Cc: kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>, Theodore Tso <tytso@google.com>, Paul Moore <pmoore@redhat.com>, Eric Paris <eparis@redhat.com>, Tyler Hicks <tyhicks@canonical.com>, zohar@us.ibm.com, john.johansen@canonical.com, Dan Carpenter <dan.carpenter@oracle.com>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 2, 2012 at 9:44 AM, Corey Bryant <coreyb@linux.vnet.ibm.com> wrote:
>
>
> On 10/02/2012 12:23 PM, Kees Cook wrote:
>>
>> On Thu, Sep 27, 2012 at 12:26 PM, Corey Bryant
>> <coreyb@linux.vnet.ibm.com> wrote:
>>>
>>> At the Linux Security Summit we began discussing the Linux Security
>>> Workgroup and some of the efforts that we can focus on.
>>>
>>> The charter of the workgroup is to provide on-going security
>>> verification of Linux kernel subsystems in order to assist in securing
>>> the
>>> Linux Kernel and maintain trust and confidence in the security of the
>>> Linux
>>> ecosystem.
>>>
>>> This may include, but is not limited to, topics such as tooling to assist
>>> in
>>> securing the Linux Kernel, verification and testing of critical
>>> subsystems
>>> for vulnerabilities, security improvements for build tools, and providing
>>> guidance for maintaining subsystem security.
>>
>>
>> Thanks for getting this rolling!
>>
>> What are the next steps? Does it make sense to try to gather a list of
>> active projects to try and see where things currently stand? (i.e who
>> is actively running smatch, trinity, etc?) Or to call attention to a
>> specific subsystem that needs direct auditing (e.g. KVM)?
>>
>> -Kees
>>
>
> No problem, thanks for the input!
>
> I think having a list of active projects is a good place to start.

I know Dan Carpenter is running smatch, as well as Fengguang Wu.
Getting details on which trees are being scanned would be good.

I know Fengguang Wu is running trinity too.

There is a collection of coccinelle scripts in the tree, but I'm not
sure if/when those are getting run by anyone. Julia, do you know if
those are being regularly run?

> Perhaps we can also add desired projects to this list, and if anyone has
> cycles to cover a project they can put their name to the project.

I was keeping a list of potential hardening work here:
https://wiki.ubuntu.com/SecurityTeam/Roadmap/KernelHardening#Upstream_Hardening
some of it is out of date.

> I'm personally trying to get time allocated to work on KVM fuzzing and/or
> static analysis in 2013.

Sounds good.

> A wiki probably makes sense for the list.  Google sites has wikis.  I can
> start one there unless there are other ideas.

Kernel.org hosts wikis as well, and James Morris already has
http://kernsec.org/. Perhaps we can use that? James, would this be
something you'd be okay with?

Thanks,

-Kees

-- 
Kees Cook
Chrome OS Security
