References: <201706100041.GFH78616.OFtOHFJSLQOMVF@I-love.SAKURA.ne.jp>
 <754b78d1-f7f9-58bd-bf74-fea9e105649a@nmatt.com>
 <20170609164315.GA1141@meriadoc.perfinion.com>
 <d84aaf19-307b-4b60-df74-4fb43a218c9c@nmatt.com>
 <CAGXu5jJt5MRU3ZdKABEbLt4qe-cCLxEm5tMH9SdUh=rtdLUV1w@mail.gmail.com>
 <201706101427.EEG90168.OtFFHSFMOVOJQL@I-love.SAKURA.ne.jp>
 <d9aca46b-97c6-4faf-b559-484feb4aa640@digikod.net>
 <1497234757.21594.280.camel@linux.vnet.ibm.com>
 <8a2300ef-1462-0e1f-2d6a-81e6020bc71f@digikod.net>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <9564a13e-3007-4cd8-5c7f-7127333da93f@schaufler-ca.com>
Date: Tue, 13 Jun 2017 14:44:31 -0700
MIME-Version: 1.0
In-Reply-To: <8a2300ef-1462-0e1f-2d6a-81e6020bc71f@digikod.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Re: [PATCH v1] shebang: restrict python
 interactive prompt/interpreter
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, keescook@chromium.org, matt@nmatt.com
Cc: jason@perfinion.com, linux-security-module@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>, kernel-hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6/13/2017 1:59 PM, Mickaël Salaün wrote:
> On 12/06/2017 04:32, Mimi Zohar wrote:
>> On Sun, 2017-06-11 at 13:44 +0200, Mickaël Salaün wrote:
>>> On 10/06/2017 07:27, Tetsuo Handa wrote:
>>>> Kees Cook wrote:
>>>>> On Fri, Jun 9, 2017 at 10:23 AM, Matt Brown <matt@nmatt.com> wrote:
>>>>>> what does everyone thing about a envp_blacklist option that is a list of
>>>>>> environmental variables that will be stripped from exec calls. This can
>>>>>> be done in the LSM hook bprm_check_security.
>>>>>>
>>>>>> Is there any reason on a hardened system why you would need the
>>>>>> PYTHONINSPECT environmental variable?
>>>>> As part of shebang, it likely makes sense to whitelist (rather than
>>>>> blacklist) the env of the restricted interpreters. Though this is
>>>>> starting to get complex. :P
>>>> Blacklisting environment variables is dangerous. I think that
>>>> administrators can afford whitelisting environment variable names.
>>>> I think that implementing whitelist of environment variable names
>>>> as an independent LSM module would be fine.
>>>>
>>>> While it is true that things starts getting complex if we check environment
>>>> variables, shebang will already become complex if it starts worrying about
>>>> updating inode number list in order to close the race window between doing
>>>> creat()+write()+close()+chmod()+rename() by the package manager and teaching
>>>> the kernel the new inode number determined by creat(). We will need an
>>>> interface for allowing the package manager to teach the kernel the new inode
>>>> number and modification of the package manager, for the kernel side is doing
>>>> inode number based blacklisting while user side can execute it before rename().
>> I don't think we're trying to protect against executing the
>> interpreter prior to the rename.  Rename, itself, would trigger
>> associating the interpreter name with an inode number.
>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>> Using filesystem xattr seems like a good idea for this kind of
>>> exceptions and instead of a hardcoded interpreter path. Something like
>>> "security.tpe.interpreter=1|2" (bitmask for interpreter-only and/or CLI)
>>> and "security.tpe.environment=HOME,LOGNAME" would be quite flexible to
>>> configure a security policy for some binaries. This could also be
>>> protected by IMA/EVM, if needed.
>> Checking for the existence of an xattr without caching is relatively
>> slow.  I'm not sure that we would want to go this route.
>>
>>> This kind of xattr should be writable by the owner of the file. The TPE
>>> LSM [1] could then take these xattr into account according to the TPE
>>> policy.
>> Security xattrs are only writable by root.
> This is currently the case but an exception for this kind of LSM could
> be allowed, or another dedicated prefix could be used.

Better yet, use "user.tpe.whatever" and explicitly look for that in your
xattr hooks, denying access based on whatever criteria you like.
You could allow it to be set, but never deleted, for example.
You can do it all within shebang without creating exceptions or new
prefixes. 
