MIME-Version: 1.0
In-Reply-To: <20170613212704.GA16726@openwall.com>
References: <20170608034349.31876-1-matt@nmatt.com> <20170608034349.31876-2-matt@nmatt.com>
 <CAGXu5jLsrTZV_xDR_MPZdkT44P1MpbDiF3Kk2HNWBXKsdY+fzg@mail.gmail.com>
 <94ba5ebb-952b-2037-799e-07306629a6f9@nmatt.com> <20170613212704.GA16726@openwall.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 14 Jun 2017 15:15:22 +0200
Message-ID: <CAG48ez2zdf93Eh=XoRsHRbF=YX6L_6B=qX=z7rbMQ6wtj6KVjA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v2 1/1] Add Trusted Path Execution
 as a stackable LSM
To: Solar Designer <solar@openwall.com>
Cc: Matt Brown <matt@nmatt.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 13, 2017 at 11:27 PM, Solar Designer <solar@openwall.com> wrote:
> Matt,
>
> I removed most CC's like before, as I don't want my voice on this to be
> too loud.
>
> On Thu, Jun 08, 2017 at 11:50:32PM -0400, Matt Brown wrote:
>> On 06/08/2017 10:38 PM, Kees Cook wrote:
>> >On Wed, Jun 7, 2017 at 8:43 PM, Matt Brown <matt@nmatt.com> wrote:
>> >>*  Issues:
>> >>   *  Can be bypassed by interpreted languages such as python. You can run
>> >>      malicious code by doing: python -c 'evil code'
>> >
>> >What's the recommendation for people interested in using TPE but
>> >having interpreters installed?
>>
>> If you don't need a given interpreter installed, uninstall it. While
>> this is common sense system hardening it especially would make a
>> difference under the TPE threat model.
>>
>> I don't have a knock down answer for this. Interpreters are a hard
>> problem for TPE.
>
> Interpreters are only a tip of the iceberg.

Some random related issues:

Scripts with shebang lines like "#!/usr/bin/env python" probably wouldn't
work anymore, at least not without special-case logic, because in this case,
env has to invoke python.

ssh and ssh-agent can load libraries from paths passed on the command
line, by design.
The alsa client library loads libraries from paths specified in user-owned
config files.

If you can use dd (or anything else that permits writing to a specific
position in a
file), you should be able to directly overwrite the memory of a
process using something like
"dd of=/proc/self/mem bs=1 seek=$STARTADDRESS < new_data".
I think one way to do this remotely is to use SFTP.

Bash has a built-in named "enable" that can load shared libraries directly
into the shell.

These are just some random examples I came up with relatively quickly,
there are probably more.
