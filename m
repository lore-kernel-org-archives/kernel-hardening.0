References: <20170608034349.31876-1-matt@nmatt.com>
 <20170608193719.2d9e8d17@lxorguk.ukuu.org.uk>
 <3f9e53a8-87d2-9773-d30b-64b89da8f3ff@nmatt.com>
 <9d175249-c9f3-daba-bae4-f60dc97795e6@digikod.net>
From: Matt Brown <matt@nmatt.com>
Message-ID: <d3b11dde-be5c-0bb8-6573-b331c593c9f7@nmatt.com>
Date: Sun, 11 Jun 2017 20:04:59 -0400
MIME-Version: 1.0
In-Reply-To: <9d175249-c9f3-daba-bae4-f60dc97795e6@digikod.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH v2 0/1] Add Trusted Path Execution as a stackable LSM
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: james.l.morris@oracle.com, serge@hallyn.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 06/11/2017 07:30 AM, Mickaël Salaün wrote:
>
> On 08/06/2017 21:01, Matt Brown wrote:
>> On 6/8/17 2:37 PM, Alan Cox wrote:
>>>> http://phrack.org/issues/52/6.html#article
>>>>
>>>> | A trusted path is one that is inside a root owned directory that
>>>> | is not group or world writable.  /bin, /usr/bin, /usr/local/bin, are
>>>> | (under normal circumstances) considered trusted.  Any non-root
>>>> | users home directory is not trusted, nor is /tmp.
>>>
>>> Note that in the real world the trusted path would and should also
>>> require that any elements of the path above that point are also locked
>>> down if you are using path based models. Ie you need to ensure nobody has
>>> the ability to rename /usr or /usr/local before you trust /usr/local/bin.
>>>
>>
>> So actually in this LSM it's not so much full paths that are trusted,
>> rather it checks that the directory containing the program is only
>> writable by root and that the program itself is only writable by root.
>>
>> For example, consider the following:
>>
>> /user/ with permissions drwxr-xr-x user user
>> /user/user-owned/ with permissions drwxr-xr-x user user
>> /user/user-owned/root-owned/ with permissions drwxr-xr-x root root
>> /user/user-owned/root-owned/exe with permissions -rwxr-xr-x root root
>
> Some tests would make this scenario clear. ;)
>
> You can take a look at how seccomp-bpf does with the test_harness.h
> helper. A new kselftest_harness.h will be available soon to not include
> a file from the seccomp-bpf directory (cf. linux-next).
>

I'll take a look at those. Thanks!

Matt
