MIME-Version: 1.0
In-Reply-To: <20170614151008.42bc57a2@alans-desktop>
References: <201706100041.GFH78616.OFtOHFJSLQOMVF@I-love.SAKURA.ne.jp>
 <754b78d1-f7f9-58bd-bf74-fea9e105649a@nmatt.com> <20170609164315.GA1141@meriadoc.perfinion.com>
 <d84aaf19-307b-4b60-df74-4fb43a218c9c@nmatt.com> <CAGXu5jJt5MRU3ZdKABEbLt4qe-cCLxEm5tMH9SdUh=rtdLUV1w@mail.gmail.com>
 <201706101427.EEG90168.OtFFHSFMOVOJQL@I-love.SAKURA.ne.jp>
 <d9aca46b-97c6-4faf-b559-484feb4aa640@digikod.net> <1497234757.21594.280.camel@linux.vnet.ibm.com>
 <1497277644.21594.319.camel@linux.vnet.ibm.com> <20170614151008.42bc57a2@alans-desktop>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Wed, 14 Jun 2017 16:37:25 -0400
Message-ID: <CAFUG7CcDA+NzqmhFhP5O4fpbzU-rYRqc9U1ssLx3ELS1r+WCAw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Re: [PATCH v1] shebang: restrict python
 interactive prompt/interpreter
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Kees Cook <keescook@chromium.org>, Matt Brown <matt@nmatt.com>, jason@perfinion.com, linux-security-module <linux-security-module@vger.kernel.org>, Daniel Micay <danielmicay@gmail.com>, kernel-hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 14, 2017 at 10:10 AM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wro=
te:
>
> On Mon, 12 Jun 2017 10:27:24 -0400
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
> > On Sun, 2017-06-11 at 22:32 -0400, Mimi Zohar wrote:
> > > On Sun, 2017-06-11 at 13:44 +0200, Micka=C3=ABl Sala=C3=BCn wrote:
> >
> > > > Using filesystem xattr seems like a good idea for this kind of
> > > > exceptions and instead of a hardcoded interpreter path. Something l=
ike
> > > > "security.tpe.interpreter=3D1|2" (bitmask for interpreter-only and/=
or CLI)
> > > > and "security.tpe.environment=3DHOME,LOGNAME" would be quite flexib=
le to
> > > > configure a security policy for some binaries. This could also be
> > > > protected by IMA/EVM, if needed.
> > >
> > > Checking for the existence of an xattr without caching is relatively
> > > slow.  I'm not sure that we would want to go this route.
> >
> > For identifying interpreters, xattrs would be too slow (without
> > caching results), but once identified, using xattrs as you suggested,
> > for specifying how interpreters can be invoked and limiting
> > environment variables, is a good idea.  Perhaps the two xattrs could
> > be combined?
>
> It's not just #! you need to cover. If I can run ld.so for my arch format
> then ld.so will helpfully let me load any ELF binary I like and run it.
>
> Alan

That depends on the threat model. Interpreted payloads are beneficial
to attackers for their light forensic footprint along with implicit
code-gen needs/powers - they dont require writing files to disk in
order to affect their goals (staging is implicitly handled by the
runtime, and behavior is tough to track). Anything going to disk is
subject to forensic recovery, malware analysis, and a host of other
concerns nobody wants to deal with when trying to compromise things
quietly. While attackers can abuse the linker to their heart's content
under certain contexts, they generally need to write files to disk in
a place where the linker can get to them, leaving more footprints or
being deterred altogether. At the payload delivery stage, remote
attackers are effectively blind and unlikely to know if their exploit
failed or the payload execution was mitigated. It has real world
value.

To go along with the notion of "perfect can be the enemy of good"
(please pardon the likely incorrect paraphrasing, second language and
all), rejecting a protection which offers coverage for a subset of
potential vectors, because it does not provide coverage for others,
leads to dead code and open holes. Is it feasible to adopt protections
which cover specific threat models with annotations on what they may
leave open such as to cover those areas in later commits? This would
also allow common work to be converged, such as LSM code dealing with
mprotect issues, path resolution as a security validator, etc.

-Boris
