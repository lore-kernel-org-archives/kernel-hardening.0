MIME-Version: 1.0
In-Reply-To: <20171122165144.07aea7ac@alans-desktop>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
 <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com> <20171122165144.07aea7ac@alans-desktop>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Fri, 24 Nov 2017 09:31:08 +0100
Message-ID: <CAJHCu1KVHOw1wN61j+SiWhFAKcJVTvKXABsgrue4qBNK5d3iFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 2/2] Protected O_CREAT open in sticky directories
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

2017-11-22 17:51 GMT+01:00 Alan Cox <gnomes@lxorguk.ukuu.org.uk>:
> On Wed, 22 Nov 2017 09:01:46 +0100
> Salvatore Mesoraca <s.mesoraca16@gmail.com> wrote:
>
>> Disallows O_CREAT open missing the O_EXCL flag, in world or
>> group writable directories, even if the file doesn't exist yet.
>> With few exceptions (e.g. shared lock files based on flock())
>
> Enough exceptions to make it a bad idea.
>
> Firstly if you care this much *stop* having shared writable directories.
> We have namespaces, you don't need them. You can give every user their
> own /tmp etc.
>
> The rest of this only make sense on a per application and directory basis
> because there are valid use cases, and that means it wants to be part of
> an existing LSM security module where you've got the context required and
> you can attach it to a specific directory and/or process.

I think that this feature should be intended more as a "debugging" feature
than as a "security" one.
When the feature implemented in the first patch is enabled, this restriction
doesn't improve security at all and it's not supposed to do it.
The first patch blocks attacks that exploit some unsafe usage of sticky
directories.
This patch, instead, doesn't block actual attacks: it detects (and maybe
blocks) the bad code that can be exploited for the attacks blocked by #1,
even if no one is attacking you in that moment.
This looks like a useful feature to me, even if you already use more
sophisticated security apparatus like LSMs or namespaces, because it makes
easy to find real vulnerabilities in software: the commit message of
patch #1 has a short list of some CVEs that this feature can detect.
Also, being just a sysctl away, it's within anyone's reach.
Probably the "debugging" goal wasn't clear from my previous message,
I'm sorry for the misunderstanding.
Thank you very much for your time,

Salvatore
