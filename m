MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <87var44a0b.fsf@concordia.ellerman.id.au>
References: <20170320065522.14839-1-andrew.donnellan@au1.ibm.com> <87var44a0b.fsf@concordia.ellerman.id.au>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 20 Mar 2017 10:01:15 -0700
Message-ID: <CAGXu5jK=GGQeGQrv-9Z__caRxu7u333boJFXRNjcqBXOspYeQw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: update architecture list in documentation
To: Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 20, 2017 at 1:39 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> Andrew Donnellan <andrew.donnellan@au1.ibm.com> writes:
>
>> Commit 65c059bcaa73 ("powerpc: Enable support for GCC plugins") enabled GCC
>> plugins on powerpc, but neglected to update the architecture list in the
>> docs. Rectify this.
>>
>> Fixes: 65c059bcaa73 ("powerpc: Enable support for GCC plugins")
>> Signed-off-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
>> ---
>>  Documentation/gcc-plugins.txt | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> It would be nice to merge this for v4.11, so the docs are up to do date
> with the code for the release.
>
> I'm not sure who owns it though, should it go via Jon as docs
> maintainer (added to CC), or via Kees tree or mine?

If you have other changes queued for v4.11, please take it via your
tree. Otherwise, perhaps the docs tree or mine? (I don't currently
have any fixes queued; I'm just trying to minimize pull requests going
to Linus...)

-Kees

-- 
Kees Cook
Pixel Security
