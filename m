Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <5064A862.20708@linux.vnet.ibm.com>
Date: Thu, 27 Sep 2012 15:26:26 -0400
From: Corey Bryant <coreyb@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Linux Security Workgroup
To: kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>, Theodore Tso <tytso@google.com>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Eric Paris <eparis@redhat.com>, Tyler Hicks <tyhicks@canonical.com>, zohar@us.ibm.com, john.johansen@canonical.com
List-ID: <kernel-hardening.lists.openwall.com>

At the Linux Security Summit we began discussing the Linux Security 
Workgroup and some of the efforts that we can focus on.

The charter of the workgroup is to provide on-going security
verification of Linux kernel subsystems in order to assist in securing 
the Linux Kernel and maintain trust and confidence in the security of 
the Linux ecosystem.

This may include, but is not limited to, topics such as tooling to 
assist in securing the Linux Kernel, verification and testing of 
critical subsystems for vulnerabilities, security improvements for build 
tools, and providing guidance for maintaining subsystem security.

For communication, we have permission to use the following mail list: 
kernel-hardening@lists.openwall.com
The list can be subscribed to at: http://www.openwall.com/lists/#subscribe

If you would like to participate or know anyone else who would like to, 
please join the mailing list or feel free to pass the word on.

The bullets below are further details based on our discussion at the 
Linux Security Summit:

General Notes:
--------------
* The idea of the workgroup came from the Linux Foundation and Ted Tso 
after the kernel.org attack.

* Malicious code wasn't inserted into the kernel tree.  git hashing 
would have detected a mismatch in kernel code quickly.  Also the PGP web 
of trust and kernel signing was an important validation measure that's 
since been taken.

* Guidelines for subsystems could be created to provide guidance for 
best practices to consider when reviewing code (e.g. detecting common 
vulnerabilities, don't leave ssh private keys around, etc).

* Development and maintenance of automated tools would assist in 
securing the kernel on an ongoing basis.

* Maintainers should have more automated tooling available to enforce 
security checks on patches as they come in.

* Daily execution (perhaps on linux-next tree or as part of build 
system) of static analysis and emailing reports out to a list and CC'ing 
authors using git blame.  Red Hat's Coverity license allows results to 
be shared with the upstream project.

* Provide verification of critical kernel subsystems (Kernel build 
infrastructure, Networking, Network file systems, KVM, Cryptographic 
library).

* Fuzz testing could be used to find potential problems in the kernel's 
interface to userspace (syscall, ioctl, KVM paravirt calls).

* More stringent rules could be adopted such as patch signing.

* The security community should share and coordinate their efforts on 
the mail list so that overlap of work items does not occur.

Resource requirements:
----------------------
* We should narrow down the working group's scope and/or priorities 
before we narrow down the resources.

* Perhaps allocating people for a limited amount of time that rotates 
would be the most attainable resource possibility.


-- 
Regards,
Corey Bryant
