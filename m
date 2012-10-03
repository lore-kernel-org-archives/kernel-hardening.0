Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 3 Oct 2012 08:45:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <20121003054535.GH13767@mwanda>
References: <5064A862.20708@linux.vnet.ibm.com>
 <CAGXu5j+Ysx+i+crdNbJjiCekuRMZT-RPW3gOHzA9Gh8q7dpWeA@mail.gmail.com>
 <506B19D5.80803@linux.vnet.ibm.com>
 <CAGXu5jK-=EZ8tmkTZ8eESAFjt9OJoPOOcKTXfmREy4ZMuB13SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jK-=EZ8tmkTZ8eESAFjt9OJoPOOcKTXfmREy4ZMuB13SQ@mail.gmail.com>
Subject: [kernel-hardening] Re: Linux Security Workgroup
To: Kees Cook <keescook@chromium.org>
Cc: Corey Bryant <coreyb@linux.vnet.ibm.com>, Julia Lawall <julia.lawall@lip6.fr>, kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>, Theodore Tso <tytso@google.com>, Paul Moore <pmoore@redhat.com>, Eric Paris <eparis@redhat.com>, Tyler Hicks <tyhicks@canonical.com>, zohar@us.ibm.com, john.johansen@canonical.com, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 02, 2012 at 03:17:29PM -0700, Kees Cook wrote:
> On Tue, Oct 2, 2012 at 9:44 AM, Corey Bryant <coreyb@linux.vnet.ibm.com> wrote:
> >
> >
> > On 10/02/2012 12:23 PM, Kees Cook wrote:
> >>
> >> On Thu, Sep 27, 2012 at 12:26 PM, Corey Bryant
> >> <coreyb@linux.vnet.ibm.com> wrote:
> >>>
> >>> At the Linux Security Summit we began discussing the Linux Security
> >>> Workgroup and some of the efforts that we can focus on.
> >>>
> >>> The charter of the workgroup is to provide on-going security
> >>> verification of Linux kernel subsystems in order to assist in securing
> >>> the
> >>> Linux Kernel and maintain trust and confidence in the security of the
> >>> Linux
> >>> ecosystem.
> >>>
> >>> This may include, but is not limited to, topics such as tooling to assist
> >>> in
> >>> securing the Linux Kernel, verification and testing of critical
> >>> subsystems
> >>> for vulnerabilities, security improvements for build tools, and providing
> >>> guidance for maintaining subsystem security.
> >>
> >>
> >> Thanks for getting this rolling!
> >>
> >> What are the next steps? Does it make sense to try to gather a list of
> >> active projects to try and see where things currently stand? (i.e who
> >> is actively running smatch, trinity, etc?) Or to call attention to a
> >> specific subsystem that needs direct auditing (e.g. KVM)?
> >>
> >> -Kees
> >>
> >
> > No problem, thanks for the input!
> >
> > I think having a list of active projects is a good place to start.
> 
> I know Dan Carpenter is running smatch, as well as Fengguang Wu.
> Getting details on which trees are being scanned would be good.
> 

I run it against linux-next x86_64 allmodconfig.

regards,
dan carpenter
