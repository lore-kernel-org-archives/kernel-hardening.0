Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <5064A862.20708@linux.vnet.ibm.com>
References: <5064A862.20708@linux.vnet.ibm.com>
Date: Tue, 2 Oct 2012 09:23:27 -0700
Message-ID: <CAGXu5j+Ysx+i+crdNbJjiCekuRMZT-RPW3gOHzA9Gh8q7dpWeA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: Linux Security Workgroup
To: Corey Bryant <coreyb@linux.vnet.ibm.com>
Cc: kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>, Theodore Tso <tytso@google.com>, Paul Moore <pmoore@redhat.com>, Eric Paris <eparis@redhat.com>, Tyler Hicks <tyhicks@canonical.com>, zohar@us.ibm.com, john.johansen@canonical.com, Dan Carpenter <dan.carpenter@oracle.com>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 27, 2012 at 12:26 PM, Corey Bryant
<coreyb@linux.vnet.ibm.com> wrote:
> At the Linux Security Summit we began discussing the Linux Security
> Workgroup and some of the efforts that we can focus on.
>
> The charter of the workgroup is to provide on-going security
> verification of Linux kernel subsystems in order to assist in securing the
> Linux Kernel and maintain trust and confidence in the security of the Linux
> ecosystem.
>
> This may include, but is not limited to, topics such as tooling to assist in
> securing the Linux Kernel, verification and testing of critical subsystems
> for vulnerabilities, security improvements for build tools, and providing
> guidance for maintaining subsystem security.

Thanks for getting this rolling!

What are the next steps? Does it make sense to try to gather a list of
active projects to try and see where things currently stand? (i.e who
is actively running smatch, trinity, etc?) Or to call attention to a
specific subsystem that needs direct auditing (e.g. KVM)?

-Kees

-- 
Kees Cook
Chrome OS Security
