Date: Wed, 12 Dec 2018 19:02:28 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH v1 0/5] Add support for O_MAYEXEC
Message-ID: <20181213030228.GM6830@bombadil.infradead.org>
References: <20181212081712.32347-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181212081712.32347-1-mic@digikod.net>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 12, 2018 at 09:17:07AM +0100, Mickaël Salaün wrote:
> The goal of this patch series is to control script interpretation.  A
> new O_MAYEXEC flag used by sys_open() is added to enable userland script
> interpreter to delegate to the kernel (and thus the system security
> policy) the permission to interpret scripts or other files containing
> what can be seen as commands.

I don't have a problem with the concept, but we're running low on O_ bits.
Does this have to be done before the process gets a file descriptor,
or could we have a new syscall?  Since we're going to be changing the
interpreters anyway, it doesn't seem like too much of an imposition to
ask them to use:

	int verify_for_exec(int fd)

instead of adding an O_MAYEXEC.
