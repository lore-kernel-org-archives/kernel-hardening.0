Date: Wed, 22 Nov 2017 16:51:44 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20171122165144.07aea7ac@alans-desktop>
In-Reply-To: <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
	<1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 2/2] Protected O_CREAT open in sticky directories
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 22 Nov 2017 09:01:46 +0100
Salvatore Mesoraca <s.mesoraca16@gmail.com> wrote:

> Disallows O_CREAT open missing the O_EXCL flag, in world or
> group writable directories, even if the file doesn't exist yet.
> With few exceptions (e.g. shared lock files based on flock())

Enough exceptions to make it a bad idea.

Firstly if you care this much *stop* having shared writable directories.
We have namespaces, you don't need them. You can give every user their
own /tmp etc.

The rest of this only make sense on a per application and directory basis
because there are valid use cases, and that means it wants to be part of
an existing LSM security module where you've got the context required and
you can attach it to a specific directory and/or process.

Alan
