MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20171128193243.4fymnjk7fplqw62x@thunk.org>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
 <1100603534.56586.1511871419952@ichabod.co-bxl> <20171128193243.4fymnjk7fplqw62x@thunk.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 28 Nov 2017 12:08:12 -0800
Message-ID: <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Djalal Harouni <tixxdz@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, James Morris <james.l.morris@oracle.com>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Geo Kozey <geokozey@mailfence.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 11:32 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Nov 28, 2017 at 01:16:59PM +0100, Geo Kozey wrote:
>>
>> Userspace can be configured in a way which is compatible with those
>> changes being on the same as it can be configured to work with
>> selinux. That means on distro level or sysadmin level it's a
>> valuable tool. It's better than nothing and it's better than using
>> some out-of-tree patches instead. Switching one sysctl would make
>> their life easier.
>
> If *selinux* can opt-in to something more stringent, such that when
> you upgrade to a new version of selinux which enables something which
> breaks all modules unless you set up the rules corretly, I don't see a
> problem with it.  It might force distributions not to go to the latest
> version of SELinux because users get cranky when their systems get
> broken, but for people like me, who *still* don't use SELinux because
> every few years, i try to enable on my development laptop running
> Debian, watch ***far*** too much stuff break. and then turn it off
> again.  So tieing it to SELinux (as far as I am concerned) reduces it to
> a previously unsolved problem.  :-)
>
> But that's different from opting it on by default for non-SELinux
> users.  To which I can only say, "Please, No."

I don't want to see this tied to SELinux because it narrows the
audience, and SELinux still hasn't solved their issues in containers.
I think the per-task setting is sufficient.

Linus, are you okay with this series if the global sysctl gets dropped?

-Kees

-- 
Kees Cook
Pixel Security
