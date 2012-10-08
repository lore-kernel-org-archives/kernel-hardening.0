Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <50733EB1.7050400@linux.vnet.ibm.com>
Date: Mon, 08 Oct 2012 16:59:29 -0400
From: Corey Bryant <coreyb@linux.vnet.ibm.com>
MIME-Version: 1.0
References: <5064A862.20708@linux.vnet.ibm.com> <CAGXu5j+Ysx+i+crdNbJjiCekuRMZT-RPW3gOHzA9Gh8q7dpWeA@mail.gmail.com> <506B19D5.80803@linux.vnet.ibm.com> <CAGXu5jK-=EZ8tmkTZ8eESAFjt9OJoPOOcKTXfmREy4ZMuB13SQ@mail.gmail.com> <507312C2.3070704@linux.vnet.ibm.com> <CAGXu5j+3hncd2gZXQck+FYO4m6gXEq0abeSgr+eTVREiQQOGAA@mail.gmail.com>
In-Reply-To: <CAGXu5j+3hncd2gZXQck+FYO4m6gXEq0abeSgr+eTVREiQQOGAA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: Linux Security Workgroup
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Julia Lawall <julia.lawall@lip6.fr>, James Morris <jmorris@namei.org>, Theodore Tso <tytso@google.com>, Paul Moore <pmoore@redhat.com>, Eric Paris <eparis@redhat.com>, Tyler Hicks <tyhicks@canonical.com>, zohar@us.ibm.com, john.johansen@canonical.com, Dan Carpenter <dan.carpenter@oracle.com>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 10/08/2012 04:00 PM, Kees Cook wrote:
> On Mon, Oct 8, 2012 at 10:52 AM, Corey Bryant <coreyb@linux.vnet.ibm.com> wrote:
>> Here's a start on the wiki.  There's not really a whole lot on it other than
>> what we've discussed on the list, but it's a start.  Comments and updates
>> are very much welcome.
>>
>> http://kernsec.org/wiki/index.php/Linux_Security_Workgroup
>
> Cool! This looks good.
>
> We may want to add a mailing list pointer to this top-level page, so
> people can find this list more directly.

Good idea, I've added this.

>
>> A couple of questions:
>>   * What should the work group's scope be?  The charter mentions " ...
>> on-going security verification of Linux kernel subsystems ... ".  I was
>> thinking it would focus more on items like: fuzzing, static analysis,
>> education for reviewing code, tooling/build security enhancements.  But I
>> have a feeling it will start to include Kernel development projects too.
>
> I think it should, yes. Finding bugs is, of course, important, but I'd
> like to have a single point of contact for development tasks too.
>

That's fine with me.  I just want to have a clear understanding more 
than anything.

>>   * Where should we document inactive, but desired, projects?  I know Kees
>> has https://wiki.ubuntu.com/SecurityTeam/Roadmap/KernelHardening but I'm
>> wondering if it makes sense to keep track of work items on the same wiki.
>
> I'll take a TODO to build up a Development section on the wiki and
> move things from the ubuntu wik

Awesome, thanks!

-- 
Regards,
Corey Bryant
