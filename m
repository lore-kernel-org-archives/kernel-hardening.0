Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CALCETrVpa1zxVXOJoYKZ0zLCdH07dBKbw0Yo-BSJRH0eP_RBvQ@mail.gmail.com>
References: <20160129010651.GA13228@www.outflux.net>
	<CALCETrVpa1zxVXOJoYKZ0zLCdH07dBKbw0Yo-BSJRH0eP_RBvQ@mail.gmail.com>
Date: Thu, 28 Jan 2016 19:03:57 -0800
Message-ID: <CABXk95CvE7O8ZL864AoVtKA7XqA_XaxA66Zz5ncpDWFSO7C19Q@mail.gmail.com>
From: Jeffrey Vander Stoep <jeffv@google.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC][PATCH] seccomp: add SECCOMP_RET_ACK for non-fatal SIGSYS
To: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Thanks! This is just what I need.

What are the drawbacks to returning the sigsys before executing the
system call? Otherwise this loses the benefit of properly reporting
registers for argument inspection.

How about SECCOMP_RET_PERMISSIVE? Describes the application rather
than the implementation. Otherwise preference is for
SECCOMP_RET_ALLOW_SIGSYS.
