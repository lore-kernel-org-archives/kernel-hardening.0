From: ebiederm@xmission.com (Eric W. Biederman)
References: <1531935483-30784-1-git-send-email-s.mesoraca16@gmail.com>
	<CAGXu5jK4q6HLDZ6jokTeDABbzVasY85Jo0HFNKYeaKWZYPjPKg@mail.gmail.com>
Date: Fri, 20 Jul 2018 08:37:04 -0500
In-Reply-To: <CAGXu5jK4q6HLDZ6jokTeDABbzVasY85Jo0HFNKYeaKWZYPjPKg@mail.gmail.com>
	(Kees Cook's message of "Thu, 19 Jul 2018 22:15:15 -0700")
Message-ID: <87effy9gfz.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [RFC] kconfig: add hardened defconfig helpers
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-doc@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

>> +CONFIG_USER_NS=n
>> +~~~~~~~~~~~~~~~~
>> +
>> +**Negative side effects level:** Medium
>
> Unfortunately I think this is High or Extreme. USER_NS gets a lot of use.
>
>> +**- Protection type:** Attack surface reduction
>> +
>> +This allows containers to use user namespaces to provide different
>> +user info for different servers.
>> +User namespaces have been abused in the past for privilege
>> +escalation.

This is not a particularly good description.

User namespaces do indeed increase the attack surface of programs that
don't use them.

User namespaces when used to build ``unprivileged containers'' remove or
at least drastically reduce the need to run as root when setting up
containers.  Which is attack surface reduction.

User namespaces make available tools that are commonly used to build
sandboxes.  Chrome for example uses users namespaces if they are
available as part of setting up it's sandbox.

User namespaces are not limited to containers.

The bugs in the attack surface that user namespaces expose that have
been used for privilege escalation have to the best of my knowledge
closed.  So while there is some danger in the increased attack surface
we are looking at implementation defects rather than design defects.

Eric
