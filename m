From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Fri, 09 Jun 2017 09:16:32 -0400
In-Reply-To: <CAGXu5jKWJV34g5TMDtJLTxF1irijay7KMK3s5oxz8ZYTJZkV5Q@mail.gmail.com>
References: <20170608034349.31876-1-matt@nmatt.com>
	 <20170608034349.31876-2-matt@nmatt.com>
	 <CAGXu5jLsrTZV_xDR_MPZdkT44P1MpbDiF3Kk2HNWBXKsdY+fzg@mail.gmail.com>
	 <94ba5ebb-952b-2037-799e-07306629a6f9@nmatt.com>
	 <1497003507.21594.177.camel@linux.vnet.ibm.com>
	 <CAGXu5jKWJV34g5TMDtJLTxF1irijay7KMK3s5oxz8ZYTJZkV5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1497014192.21594.185.camel@linux.vnet.ibm.com>
Subject: [kernel-hardening] Re: [PATCH v2 1/1] Add Trusted Path Execution as a stackable LSM
To: Kees Cook <keescook@chromium.org>
Cc: Matt Brown <matt@nmatt.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, LKML <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2017-06-09 at 05:55 -0700, Kees Cook wrote:
> On Fri, Jun 9, 2017 at 3:18 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Thu, 2017-06-08 at 23:50 -0400, Matt Brown wrote:
> >> >>
> >> >> *  Issues:
> >> >>    *  Can be bypassed by interpreted languages such as python. You can run
> >> >>       malicious code by doing: python -c 'evil code'
> >> >
> >> > What's the recommendation for people interested in using TPE but
> >> > having interpreters installed?
> >> >
> >>
> >> If you don't need a given interpreter installed, uninstall it. While
> >> this is common sense system hardening it especially would make a
> >> difference under the TPE threat model.
> >>
> >> I don't have a knock down answer for this. Interpreters are a hard
> >> problem for TPE.
> >
> > You might be interested in the minor LSM named "shebang", that I
> > posted as a proof of concept back in January, which restricts the
> > python interactive prompt/interpreter, but allows the scripts
> > themselves to be executed.
> 
> https://patchwork.kernel.org/patch/9547405/
> 
> Maybe these could be merged and the interpreter string could be made
> into a configurable list?

I updated shebang, but didn't bother to post it, as nobody seemed to
be interested at the time.  The updated version already has support
for the configurable list. Re-posting ...

Mimi
